function convertedExcelData = convertExcel(excelFile, fastaFile)
    [num_excel, txt_excel, excelData] = xlsread(excelFile);
    fastaData = fastaread(fastaFile,  'blockread', [1 Inf]);
    format long g
    excelSize = size(excelData);
    convertedExcelData = cell(1);
    count=0;
    for i=1:length(fastaData)
        for j=1:excelSize(1)
            if(strcmp(fastaData(i).Header, excelData(j, 3)))
                count=count+1;
            end
        end
    end
    count
end

