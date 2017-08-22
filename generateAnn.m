function bestAnnStruct = generateAnn(fastaData, excelData, noOfIter, noOfHiddenNeurons, codification, antibody, classArgs, networkType)
    %returns a struct containing the resulting neural network, training
    %data, the input parameters and the output data necessary to draw plots
    if ~exist('noOfIter', 'var')
        noOfIter = 100;
    end
    if ~exist('noOfHiddenNeurons', 'var')
        noOfHiddenNeurons = 10;
    end
    if ~exist('codification', 'var')
        codification = 'A (Numerical)';
    end
    if ~exist('antibody', 'var')
        antibody = 'antibody_2F5';
    end
    if ~exist('classArgs', 'var')
        classArgs = [0 0 0];
    end
    if ~exist('networkType', 'var')
        networkType = 'Feedforward Neural Network';
    end   
    
    if(strcmp(networkType, 'Self Organizing Map'))
        [codifiedFastaData filteredFastaData] = codifyFasta(fastaData, codification);
        ann = selforgmap([6 6]);
        if(strcmp(codification, 'B (Properties)'))
            codifiedFastaData = vertcat(codifiedFastaData{1}, codifiedFastaData{2}, codifiedFastaData{3}, codifiedFastaData{4}, codifiedFastaData{5}, codifiedFastaData{6});
        end
        [ann tr] = train(ann, codifiedFastaData);
        clusterHeader = [];
        clusterContents = cell(1, 36);
        fastaSize = size(filteredFastaData);
        for i=1:fastaSize(2)
            annOutput = ann(codifiedFastaData(:, i));
            clusterContents{find(annOutput)}(end+1) = {filteredFastaData(i).Header};
        end
        %sort the clusters of the SOM with the most populated ones at the
        %beggining and save it to the return struct
        [clusterContents, clusterHeader] = sortByLengthDesc(clusterContents);
        plotData = struct('FastaData', codifiedFastaData, 'ClusterHeader', clusterHeader, 'ClusterContents', []);
        plotData.ClusterContents = clusterContents;
        bestAnnStruct = struct('ANN', ann, 'TR', tr, 'Codification', codification, 'Antibody', antibody, 'ClassArgs', classArgs, 'NetworkType', networkType, 'AntibodySetLimits', [0 0], 'PlotData', plotData);
        figure(1);
        plotsomhits(ann, codifiedFastaData);
    end
    if(strcmp(networkType, 'Feedforward Neural Network'))
        [commonFastaData, commonAntibodyData] = getCommonElements(fastaData, excelData, antibody);
        commonCodifiedFastaData = codifyFasta(commonFastaData, codification);
        if(classArgs(1))
            antibodySetLimits = [0 0];
            commonAntibodyData = convertToClasses(commonAntibodyData, classArgs(2), classArgs(3));            
        else
            antibodySetLimits = [min(commonAntibodyData) max(commonAntibodyData)];
            commonAntibodyData = (commonAntibodyData - min(commonAntibodyData)) / (max(commonAntibodyData) - min(commonAntibodyData));
        end
        if(strcmp(codification, 'A (Numerical)'))
            ann = fitnet(noOfHiddenNeurons, 'trainlm');
        end
        if(strcmp(codification, 'B (Properties)'))
            ann = createMultiInputAnn(6, noOfHiddenNeurons);            
        end
        annStorage = struct('ANN', {}, 'TR', {}, 'Codification', [], 'Antibody', [], 'ClassArgs', [], 'NetworkType', [], 'AntibodySetLimits', [], 'PlotData', []);
        bestPerf = Inf;
        bestPerfIndex = 1;
        %train the neural network multiple times and select the one with
        %the best performance (the minimum)
        for i=1:noOfIter
            [ann tr] = train(ann, commonCodifiedFastaData, commonAntibodyData);            
            tempAnnStorage = struct('ANN', ann, 'TR', tr, 'Codification', codification, 'Antibody', antibody, 'ClassArgs', classArgs, 'NetworkType', networkType, 'AntibodySetLimits', antibodySetLimits, 'PlotData', []);
            annStorage = [annStorage; tempAnnStorage];
            if(min(tr.perf) < bestPerf)
                bestPerf = min(tr.perf);
                bestPerfIndex = i;
            end
        end
        bestAnnStruct = annStorage(bestPerfIndex);
        annOutput = bestAnnStruct.ANN(commonCodifiedFastaData);
        if(strcmp(codification, 'B (Properties)'))
            annOutput = annOutput{1};      
        end
        %create and save the struct containing the data for the reggression plot
        trOut = annOutput(bestAnnStruct.TR.trainInd);
        vOut = annOutput(bestAnnStruct.TR.valInd);
        tsOut = annOutput(bestAnnStruct.TR.testInd);
        trTarg = commonAntibodyData(bestAnnStruct.TR.trainInd);
        vTarg = commonAntibodyData(bestAnnStruct.TR.valInd);
        tsTarg = commonAntibodyData(bestAnnStruct.TR.testInd);
        plotData = struct('RegressionPlot', {{trTarg trOut; vTarg vOut; tsTarg tsOut}});
        bestAnnStruct.PlotData = plotData;
        
        figure(1);
        plotregression(trTarg, trOut, 'Train', vTarg, vOut, 'Validation', tsTarg, tsOut, 'Testing');
        figure(2);
        plotPLSRegress(commonCodifiedFastaData, commonAntibodyData);
    end
end
