function [cellArray, indexes] = sortByLengthDesc(cellArray)
    indexes = 1:length(cellArray);
    for i=1:length(cellArray)
        for j=1:length(cellArray)-i
            if(length(cellArray{j}) < length(cellArray{j+1}))
                auxCell = cellArray{j};
                cellArray{j} = cellArray{j+1};
                cellArray{j+1} = auxCell;
                
                auxIndex = indexes(j);
                indexes(j) = indexes(j+1);
                indexes(j+1) = auxIndex;
            end
        end
    end
end

