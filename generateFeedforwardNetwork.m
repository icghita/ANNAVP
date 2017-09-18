function bestAnnStruct = generateFeedforwardNetwork(networkName, networkType, codification, fastaData, excelData, noOfIter, noOfHiddenNeurons, trainingFunction, antibody, dataLimitsArgs, aditionalResourcesArgs, classArgs)
    %returns a struct containing the resulting neural network, training
    %data, the input parameters and the output data necessary to draw plots
    keys = {'Levenberg-Marquardt','BFGS Quasi-Newton','Resilient Backpropagation','Scaled Conjugate Gradient','Conjugate Gradient with Powell/Beale Restarts','Fletcher-Powell Conjugate Gradient','Polak-Ribiére Conjugate Gradient','One Step Secant','Variable Learning Rate Gradient Descent','Gradient Descent with Momentum','Gradient Descent','Bayesian Regularization'};
    values = {'trainlm','trainbfg','trainrp','trainscg','traincgb','traincgf','traincgp','trainoss','traingdx','traingdm','traingd','trainbr'};
    trainingFunctionsMap = containers.Map(keys, values);     

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
        ann = fitnet(noOfHiddenNeurons, trainingFunctionsMap(trainingFunction));
    else
        if(strcmp(codification, 'A-9 (Properties codification)'))
            ann = createMultiInputAnn(9, noOfHiddenNeurons, trainingFunctionsMap(trainingFunction));
        else
            ann = createMultiInputAnn(6, noOfHiddenNeurons, trainingFunctionsMap(trainingFunction));
        end
    end
    ann.divideParam.trainRatio = dataLimitsArgs(1)/100;
    ann.divideParam.valRatio = dataLimitsArgs(2)/100 - dataLimitsArgs(1)/100;
    ann.divideParam.testRatio = 1 - dataLimitsArgs(2)/100;
    
    annStorage = struct('ANN', {}, 'TR', {}, 'Codification', [], 'Antibody', [], 'ClassArgs', [], 'NetworkName', [], 'NetworkType', [], 'AntibodySetLimits', [], 'PlotData', []);
    bestPerf = Inf;
    bestPerfIndex = 1;
    if(aditionalResourcesArgs(1))
        useParallel = 'yes';
        poolObj = parpool;
    else
        useParallel = 'no';
    end
    if(aditionalResourcesArgs(2))
        useGpu = 'yes';
        ann.inputs{1}.processFcns = {'mapminmax'};
    else
        useGpu = 'no';
    end
    %train the neural network multiple times and select the one with
    %the best performance (the minimum)
    for i=1:noOfIter
        [ann tr] = train(ann, commonCodifiedFastaData, commonAntibodyData, 'useParallel', useParallel, 'useGPU', useGpu);            
        tempAnnStorage = struct('ANN', ann, 'TR', tr, 'Codification', codification, 'Antibody', antibody, 'ClassArgs', classArgs, 'NetworkName', networkName, 'NetworkType', networkType, 'AntibodySetLimits', antibodySetLimits, 'PlotData', []);
        annStorage = [annStorage; tempAnnStorage];
        if(min(tr.perf) < bestPerf)
            bestPerf = min(tr.perf);
            bestPerfIndex = i;
        end
    end
    if(aditionalResourcesArgs(1))
        delete(poolObj);
    end
    bestAnnStruct = annStorage(bestPerfIndex);
    annOutput = bestAnnStruct.ANN(commonCodifiedFastaData);
    if(strcmp(codification, 'A-6 (Properties codification)') || strcmp(codification, 'A-9 (Properties codification)') || strcmp(codification, 'B (Raw Properties)'))
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
