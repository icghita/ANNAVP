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
                tempArray = double(aa2int(tempString))/range;
            end
            if(strcmp(codification, 'B (Properties)'))
                tempArray = aa2properties(tempString);
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
    end
    if(strcmp(codification, 'B (Properties)'))
        codifiedFasta = {[];[];[];[];[];[]};
        for i=1:6:length(codifiedFastaMatrix(:,1))
            codifiedFasta{1} = vertcat(codifiedFasta{1}, codifiedFastaMatrix(i,:));
            codifiedFasta{2} = vertcat(codifiedFasta{2}, codifiedFastaMatrix(i+1,:));
            codifiedFasta{3} = vertcat(codifiedFasta{3}, codifiedFastaMatrix(i+2,:));
            codifiedFasta{4} = vertcat(codifiedFasta{4}, codifiedFastaMatrix(i+3,:));
            codifiedFasta{5} = vertcat(codifiedFasta{5}, codifiedFastaMatrix(i+4,:));
            codifiedFasta{6} = vertcat(codifiedFasta{6}, codifiedFastaMatrix(i+5,:));
        end
    end
end

