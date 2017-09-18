function ann = createMultiInputAnn(numInputs, numHiddenNeurons, trainingFunction)
    %creates a feedforward neural network with numInputs layers (each layer
    %coresponds to an input) and each layer has numHiddenNeurons neurons
    ann = network;
    ann.numInputs = numInputs;
    ann.numLayers = numInputs + 1;
    for i=1:numInputs
        ann.biasConnect(i) = 1;
        ann.inputConnect(i, i) = 1;
        ann.layerConnect(numInputs + 1, i) = 1;
        ann.layers{i}.size = numHiddenNeurons;
        ann.layers{i}.transferFcn = 'tansig';
        ann.layers{i}.initFcn = 'initnw';
        ann.inputWeights{i,i}.learnFcn = 'learngdm';
    end
    ann.outputConnect(numInputs + 1) = 1;
    ann.initFcn = 'initlay';
    ann.performFcn = 'mse';
    ann.trainFcn = trainingFunction;
    ann.divideFcn = 'dividerand';
    ann.plotFcns = {'plotperform','plottrainstate','ploterrhist','plotregression','plotfit'};
end

