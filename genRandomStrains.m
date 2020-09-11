function genRandomStrains(fastaFilepath, numEntries, outputPath)
    %split data in fasta files coresponding to the columns in the excel
    %deactivate scientific notation
    format long g
    fastaData = fastareadCustom(fastaFilepath);
    
    randomStrains = randi([1 length(fastaData)], 1, numEntries);
    fid = fopen(outputPath,'wt');
    for j=1:numEntries
        fprintf(fid, '>%s\n%s\n', fastaData(randomStrains(j)).Header, fastaData(randomStrains(j)).Sequence);
    end
    fclose(fid);
end