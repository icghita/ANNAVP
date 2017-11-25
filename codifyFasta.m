function [codifiedFasta, filteredFasta] = codifyFasta(fastaData, codification, range)
    %returns codifiedFasta - for codification A: a matrix with inputs vertically
    %and samples horizontally; - for codification B: a structure containing 
    %6 matrices with the organization of the matrix of codification A
    %filteredFasta - fastaData with the entries containing uncodified
    %symbols removed
    if ~exist('codification', 'var')
        codification = 'A (Numerical)';
    end    
    if ~exist('range', 'var')
        range = 25;
    end
    
    filteredFasta = struct('Header', {}, 'Sequence', {});
    codifiedFastaMatrix = [];
    isFirstIter = true;
    for i=1:length(fastaData)
        tempString = fastaData(i).Sequence';
        %ignores entries which contain uncodified symbols
        if(isempty(regexpi(tempString', '#')))
            if(strcmp(codification, 'A (Numerical)'))
                tempArray = aa2intCustom(tempString)/range;
            else
                tempArray = aa2properties(tempString, codification);
            end
            if(isFirstIter || length(codifiedFastaMatrix) == length(tempArray))
                codifiedFastaMatrix = horzcat(codifiedFastaMatrix, tempArray);
                filteredFasta(end+1) = fastaData(i);
                isFirstIter = false;
            end
        end
    end
    if(strcmp(codification, 'A (Numerical)'))
        codifiedFasta = codifiedFastaMatrix;
    else
        if(strcmp(codification, 'A-9 (Properties codification)'))
            numProperties = 9;
        else
            numProperties = 6;
        end
        codifiedFasta = cell(numProperties, 1);
        for i=1:numProperties:length(codifiedFastaMatrix(:,1))
            for j=1:numProperties
                codifiedFasta{j} = vertcat(codifiedFasta{j}, codifiedFastaMatrix(i+j-1,:));
            end
        end
    end
end

