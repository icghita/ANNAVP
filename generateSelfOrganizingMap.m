function annStruct = generateSelfOrganizingMap(networkName, networkType, codification, fastaData, mapTopology, mapWidth, mapHeight, trainingSteps, neighborhoodSize, distanceFunction)
    %returns a struct containing the resulting neural network, training
    %data, the fastaData and neuron indexes header necessary to draw the
    %somhits plot and the cluster table
    
    switch mapTopology
        case 'Hexagonal'
            mapTopologyParam = 'hextop';
        case 'Rectangular'
            mapTopologyParam = 'gridtop';
        case 'Random'
            mapTopologyParam = 'randtop';
    end
    [codifiedFastaData filteredFastaData] = codifyFasta(fastaData, codification);
    ann = selforgmap([mapWidth mapHeight], trainingSteps, neighborhoodSize, mapTopologyParam, distanceFunction);
    if(strcmp(codification, 'A-6 (Properties codification)') || strcmp(codification, 'A-9 (Properties codification)') || strcmp(codification, 'B (Raw Properties)'))
        if(strcmp(codification, 'A-9 (Properties codification)'))
            numProperties = 9;
        else
            numProperties = 6;
        end
%        auxData = [];
%        for i=1:numProperties
%            auxData = vertcat(auxData, codifiedFastaData{i});
%        end
%        codifiedFastaData = auxData;
        ann.numInputs = numProperties;
        ann.inputConnect = ones(1, numProperties);
        ann = configure(ann, codifiedFastaData);
    end
    
    [ann tr] = train(ann, codifiedFastaData);
    clusterContents = cell(1, mapWidth*mapHeight);
    fastaSize = size(filteredFastaData);
    for i=1:fastaSize(2)
        if(strcmp(codification, 'A-6 (Properties codification)') || strcmp(codification, 'A-9 (Properties codification)') || strcmp(codification, 'B (Raw Properties)'))
            propertiesInput = cell(numProperties, 1);
            for j=1:numProperties
                propertiesInput{j} = codifiedFastaData{j}(:, i);
            end
            annOutput = ann(propertiesInput);
            clusterContents{find(annOutput{1})}(end+1) = {filteredFastaData(i).Header};
        else
            annOutput = ann(codifiedFastaData(:, i));
            clusterContents{find(annOutput)}(end+1) = {filteredFastaData(i).Header};
        end
    end
    if(strcmp(codification, 'A-6 (Properties codification)') || strcmp(codification, 'A-9 (Properties codification)') || strcmp(codification, 'B (Raw Properties)'))
        h = msgbox('Plot SOM Hits is not available for multiple input layers', 'Warning');
    else
        figure(1);
        plotsomhits(ann, codifiedFastaData);
    end
    %sort the clusters of the SOM with the most populated ones at the
    %beggining and save it to the return struct
    [clusterContents, clusterHeader] = sortByLengthDesc(clusterContents);
    aux = codifiedFastaData;
    codifiedFastaData = cell(1);
    codifiedFastaData{1} = aux;
    aux = clusterContents;
    clusterContents = cell(1);
    clusterContents{1} = aux;
    plotData = struct('FastaData', codifiedFastaData, 'ClusterHeader', clusterHeader, 'ClusterContents', clusterContents);
%    plotData.ClusterContents = clusterContents;
    annStruct = struct('ANN', ann, 'TR', tr, 'Codification', codification, 'Antibody', 'NaN', 'ClassArgs', [0 0 0], 'NetworkName', networkName, 'NetworkType', networkType, 'AntibodySetLimits', [0 0], 'PlotData', plotData);
end

