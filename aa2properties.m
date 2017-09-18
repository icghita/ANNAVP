function convertedSequence = aa2properties(sequence, codification)
    %returns an array with the properties for each aminoacid one after another
    %map with aminoacid properties codification
    keys = {'A','C','D','E','F','G','H','I','K','L','M','N','P','Q','R','S','T','V','W','Y','B','Z','X','*','-','?'};
    values = {
         {0.1677 0.4433 0.2490 0.3951 0.0 0.5 },
         {0.3114 0.5506 0.2048 0.7441 0.0 0.5 },
         {0.3054 0.4532 0.8675 1.0000 0.0 0.5 },
         {0.4970 0.5567 0.8112 0.9136 0.0 0.5 },
         {0.7725 0.8976 0.0763 0.0370 0.6667 0.5 },
         {0.0 0.0 1.0 0.5062 0.0 0.5 },
         {0.5569 0.5632 0.1124 0.6790 0.5556 0.5 },
         {0.6467 0.9852 0.6707 0.0370 0.0 0.5 },
         {0.6946 0.6738 0.6867 0.7901 0.0 1.0 },
         {0.6467 0.9852 0.2811 0.0 0.0 0.5 },
         {0.6108 0.7033 0.0 0.0988 0.0 0.5 },
         {0.3174 0.5156 0.6747 0.8272 0.0 0.5 },
         {0.1766 0.7679 0.8594 0.3827 0.0 0.5 },
         {0.4910 0.6048 0.7952 0.6914 0.0 0.5 },
         {0.7246 0.5955 0.9398 0.6914 0.0 1.0 },
         {0.1737 0.3222 0.8514 0.5309 0.0 0.5 },
         {0.3473 0.6771 0.5984 0.4568 0.0 0.5 },
         {0.4850 0.9945 0.3655 0.1235 0.0 0.5 },
         {1.0 1.0 0.0402 0.0617 1.0 0.5 },
         {0.7964 0.8008 0.5020 0.1605 0.6667 0.5 }         
            };         
    valuesExtra = {
         {(values{3}{1} + values{12}{1})/2 (values{3}{2} + values{12}{2})/2 (values{3}{3} + values{12}{3})/2 (values{3}{4} + values{12}{4})/2 (values{3}{5} + values{12}{5})/2 (values{3}{6} + values{12}{6})/2 },
         {(values{4}{1} + values{14}{1})/2 (values{4}{2} + values{14}{2})/2 (values{4}{3} + values{14}{3})/2 (values{4}{4} + values{14}{4})/2 (values{4}{5} + values{14}{5})/2 (values{4}{6} + values{14}{6})/2 },
         {0 0 0 0 0 0},
         {0 0 0 0 0 0},
         {0 0 0 0 0 0},
         {0 0 0 0 0 0}
                  };
    values = [values; valuesExtra];
    aaPropertiesMap = containers.Map(keys, values);    
    
    values = {
        {5 3 5 0 0 10},
        {4 5 5 0 0 10},
        {10 5 0 0 1 10},
        {10 6 0 0 1 0},
        {1 8 5 10 0 10},
        {5 2 5 0 0 0},
        {5 6 5 0 1 0},
        {3 7 5 0 0 0},
        {10 7 10 0 2 10},
        {3 7 5 0 0 0},
        {3 7 5 0 0 5},
        {6 5 5 0 2 0},
        {5 5 5 0 0 0},
        {6 6 5 0 2 10},
        {10 8 10 0 4 6},
        {6 4 5 0 1 0},
        {5 5 5 0 1 10},
        {3 6 5 0 0 7},
        {0 10 5 10 1 0},
        {2 8 5 10 1 8}
            };
    valuesExtra = {
         {round((values{3}{1} + values{12}{1})/2) round((values{3}{2} + values{12}{2})/2) round((values{3}{3} + values{12}{3})/2) round((values{3}{4} + values{12}{4})/2) round((values{3}{5} + values{12}{5})/2) round((values{3}{6} + values{12}{6})/2)},
         {round((values{4}{1} + values{14}{1})/2) round((values{4}{2} + values{14}{2})/2) round((values{4}{3} + values{14}{3})/2) round((values{4}{4} + values{14}{4})/2) round((values{4}{5} + values{14}{5})/2) round((values{4}{6} + values{14}{6})/2)},
         {0 0 0 0 0 0},
         {0 0 0 0 0 0},
         {0 0 0 0 0 0},
         {0 0 0 0 0 0}
                  };             
    values = [values; valuesExtra];
    aa6PropertiesCodificationMap = containers.Map(keys, values);
    
    values = {
        {1 0 0 0 0 1 0 0 0},
        {0 0 0 0 0 1 0 0 1},
        {0 0 1 0 0 1 0 0 0},
        {0 0 1 0 0 0 1 0 0},
        {1 0 0 1 0 0 1 0 1},
        {0 0 0 0 0 1 0 0 0},
        {0 1 0 1 0 0 1 1 1},
        {1 0 0 0 1 0 0 1 1},
        {0 1 0 0 0 0 1 1 1},
        {1 0 0 0 1 0 0 0 1},
        {1 0 0 0 0 0 1 0 0},
        {0 0 0 0 0 1 0 0 0},
        {1 0 0 0 0 0 0 1 0},
        {0 0 0 0 0 0 1 0 0},
        {0 1 0 0 0 0 1 1 0},
        {0 0 0 0 0 1 0 1 1},
        {0 0 0 0 0 1 0 1 0},
        {1 0 0 0 1 1 0 1 0},
        {1 0 0 1 0 0 1 1 0},
        {0 0 0 1 0 0 1 1 1}
            };
        valuesExtra = {
         {values{3}{1} & values{12}{1} values{3}{2} & values{12}{2} values{3}{3} & values{12}{3} values{3}{4} & values{12}{4} values{3}{5} & values{12}{5} values{3}{6} & values{12}{6} values{3}{7} & values{12}{7} values{3}{8} & values{12}{8} values{3}{9} & values{12}{9}},
         {values{4}{1} & values{14}{1} values{4}{2} & values{14}{2} values{4}{3} & values{14}{3} values{4}{4} & values{14}{4} values{4}{5} & values{14}{5} values{4}{6} & values{14}{6} values{4}{7} & values{14}{7} values{4}{8} & values{14}{8} values{4}{9} & values{14}{9}},
         {0 0 0 0 0 0 0 0 0},
         {0 0 0 0 0 0 0 0 0},
         {0 0 0 0 0 0 0 0 0},
         {0 0 0 0 0 0 0 0 0}
                  };
    values = [values; valuesExtra];
    aa9PropertiesCodificationMap = containers.Map(keys, values);
    
    convertedSequence = [];
    if(strcmp(codification, 'A-9 (Properties codification)'))
        maxIndex = 9;
    else
        maxIndex = 6;
    end
    for i=1:length(sequence)
        try
            switch codification
                case 'A-6 (Properties codification)'
                    tempProperties = aa6PropertiesCodificationMap(sequence(i));
                case 'A-9 (Properties codification)'
                    tempProperties = aa9PropertiesCodificationMap(sequence(i));
                case 'B (Raw Properties)'
                    tempProperties = aaPropertiesMap(sequence(i));
            end
        catch
            tempProperties = num2str(zeros(1, maxIndex));
        end
        for j=1:maxIndex
            convertedSequence(end+1) = tempProperties{j};
        end
    end
    convertedSequence = convertedSequence';
end

