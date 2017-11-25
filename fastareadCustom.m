function fastaData = fastareadCustom(fastaFile)
    fileID = fopen(fastaFile);
    fastaContent = textscan(fileID, '%s');
    lines = fastaContent{1};
    fastaHeaders = {};
    fastaSequences = {};
    i = 1;
    while i <= length(lines)
        if(strcmp(lines{i}(1), '>'))
            fastaHeaders{end+1} = lines{i}(2:length(lines{i}));
            fastaSequences{end+1} = [];
        else
            fastaSequences{end} = strcat(fastaSequences{end}, lines{i});
        end
        i = i + 1;
    end
    fastaData = struct('Header', fastaHeaders, 'Sequence', fastaSequences);
    fclose(fileID);
end

