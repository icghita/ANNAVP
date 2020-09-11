function splitFastaStrains(fastaFilepath, excelFilepath, outputFolderPath)
    %split data in fasta files coresponding to the columns in the excel
    %deactivate scientific notation
    format long g
    fastaData = fastareadCustom(fastaFilepath);
    [num_excel, txt_excel, excelData] = xlsread(excelFilepath);
    excelSize = size(excelData);
    if ~exist(outputFolderPath, 'dir')
        mkdir(outputFolderPath);
    end
    
    for j=1:excelSize(2)
        filename = strcat('./',outputFolderPath,'/','cluster_num_',num2str(j),'_name_',num2str(excelData{1,j}),'.fasta');
        fid = fopen(filename,'wt');
        for k=1:length(fastaData)
            for i=2:excelSize(1)
                if(strcmp(fastaData(k).Header, excelData{i,j}))
                    fprintf(fid, '>%s\n%s\n', fastaData(k).Header, fastaData(k).Sequence);
                    break;
                end
            end
        end
        fclose(fid);
    end
end
