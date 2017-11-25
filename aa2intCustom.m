function outputArray = aa2intCustom(inputString)
    keys = {'A','R','N','D','C','Q','E','G','H','I','L','K','M','F','P','S','T','W','Y','V','B','Z','X','*','-','?'};
    values = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,0};
    aaIntMap = containers.Map(keys, values);
    outputArray = zeros(length(inputString), 1);
    for i=1:length(inputString)
        outputArray(i) = aaIntMap(inputString(i));
    end
end

