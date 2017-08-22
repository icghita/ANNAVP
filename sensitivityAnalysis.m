function [inputNumbers, deltaPerf] = sensitivityAnalysis(ann, fastaData, excelData, codification, antibody, classArgs)
    %returns: inputNumbers - the indices of inputs; 
    %and deltaPerf - the difference in performanance between the original
    %neural network and the neural network with one of its inputs set to zero
    [commonFastaData, commonAntibodyData] = getCommonElements(fastaData, excelData, antibody);
    commonCodifiedFastaData = codifyFasta(commonFastaData, codification);
    if(classArgs(1))
        commonAntibodyData = convertToClasses(commonAntibodyData, classArgs(2), classArgs(3));
    else
        commonAntibodyData = (commonAntibodyData - min(commonAntibodyData)) / (max(commonAntibodyData) - min(commonAntibodyData));
    end
    annOutput = ann(commonCodifiedFastaData);
    originalPerf = perform(ann, commonAntibodyData, annOutput);
    if(strcmp(codification, 'A (Numerical)'))
        inputSize = size(commonCodifiedFastaData);
        inputNumbers = [1:inputSize(1)];
        deltaPerf = zeros(1, inputSize(1));
        for i=1:inputSize(1)
            tempArray = commonCodifiedFastaData(i,:);
            commonCodifiedFastaData(i,:) = zeros(1, length(tempArray));
            annOutput = ann(commonCodifiedFastaData);
            tempPerf = perform(ann, commonAntibodyData, annOutput);
            deltaPerf(i) = originalPerf - tempPerf;
            commonCodifiedFastaData(i,:) = tempArray;
        end
    end
    if(strcmp(codification, 'B (Properties)'))
        inputSize = size(commonCodifiedFastaData{1});
        inputNumbers = [1:inputSize(1)];
        deltaPerf = zeros(1, inputSize(1));
        for i=1:inputSize(1)
            tempMatrix = [commonCodifiedFastaData{1}(i,:); commonCodifiedFastaData{2}(i,:); commonCodifiedFastaData{3}(i,:); commonCodifiedFastaData{4}(i,:); commonCodifiedFastaData{5}(i,:); commonCodifiedFastaData{6}(i,:)];
            commonCodifiedFastaData{1}(i,:) = zeros(1, length(tempMatrix(1,:)));
            commonCodifiedFastaData{2}(i,:) = zeros(1, length(tempMatrix(1,:)));
            commonCodifiedFastaData{3}(i,:) = zeros(1, length(tempMatrix(1,:)));
            commonCodifiedFastaData{4}(i,:) = zeros(1, length(tempMatrix(1,:)));
            commonCodifiedFastaData{5}(i,:) = zeros(1, length(tempMatrix(1,:)));
            commonCodifiedFastaData{6}(i,:) = zeros(1, length(tempMatrix(1,:)));
            annOutput = ann(commonCodifiedFastaData);
            tempPerf = perform(ann, commonAntibodyData, annOutput);
            deltaPerf(i) = originalPerf - tempPerf;
            commonCodifiedFastaData{1}(i,:) = tempMatrix(1,:);
            commonCodifiedFastaData{2}(i,:) = tempMatrix(2,:);
            commonCodifiedFastaData{3}(i,:) = tempMatrix(3,:);
            commonCodifiedFastaData{4}(i,:) = tempMatrix(4,:);
            commonCodifiedFastaData{5}(i,:) = tempMatrix(5,:);
            commonCodifiedFastaData{6}(i,:) = tempMatrix(6,:);
        end
    end
end