function [commonFastaData, commonAntibodyData] = getCommonElements(fastaData, excelData, antibody)
    %return the fasta and excel entries that have a correspondant in eachother
    %deactivate scientific notation
    format long g
    maxIndexOfAntibodies = length(excelData(1,:));
    antibodyNames = excelData(1, 2:maxIndexOfAntibodies);   
    commonFastaHeader = {};
    commonFastaSequence = {};
    commonAntibodyData = [];
    
    for i=1:maxIndexOfAntibodies-1
        if(strcmp(antibodyNames(i), antibody))
            antibodyIndex = i+1;
            break;
        end
    end
    for i=1:length(fastaData)
        for j=2:length(excelData(:,1))
            if(strcmp(num2str(excelData{j,1}), num2str(fastaData(i).Header)))
                commonFastaHeader{end+1} = fastaData(i).Header;
                commonFastaSequence{end+1} = fastaData(i).Sequence;
                commonAntibodyData(end+1) = excelData{j,antibodyIndex};
                break;
            end
        end
    end
    commonFastaData = struct('Header', commonFastaHeader, 'Sequence', commonFastaSequence);
end
