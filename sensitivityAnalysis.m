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
    else
        if(strcmp(codification, 'A-9 (Properties codification)'))
            numProperties = 9;
        else
            numProperties = 6;
        end
        inputSize = size(commonCodifiedFastaData{1});
        inputNumbers = [1:inputSize(1)];
        deltaPerf = zeros(1, inputSize(1));
        for i=1:inputSize(1)
            tempMatrix = [];
            for j=1:numProperties
                tempMatrix = [tempMatrix; commonCodifiedFastaData{j}(i,:)];
                commonCodifiedFastaData{j}(i,:) = zeros(1, length(commonCodifiedFastaData{j}(i,:)));
            end
            annOutput = ann(commonCodifiedFastaData);
            tempPerf = perform(ann, commonAntibodyData, annOutput);
            deltaPerf(i) = originalPerf - tempPerf;
            for j=1:numProperties
                commonCodifiedFastaData{j}(i,:) = tempMatrix(j,:);
            end
        end
    end
end