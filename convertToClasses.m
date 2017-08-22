function convertedArray = convertToClasses(array, firstClasslimit, secondClassLimit)
    convertedArray = array;
    for i=1:length(array)
        if(array(i) < firstClasslimit)
            convertedArray(i) = 0;
        end
        if(array(i) >= firstClasslimit && array(i) < secondClassLimit)
            convertedArray(i) = 0.5;
        end
        if(array(i) >= secondClassLimit)
            convertedArray(i) = 1;
        end
    end
end

