function [finalImage,success,met] = get_map(path)

%% InvCAGI
% jpegList = {'ADQ2|ADQ1','CAGI','InvCAGI'};
jpegList = {'ADQ1','CAGI','InvCAGI'};  %% curious how it performs in overal on its own = answer in short - better
tifList = {'BLK','ADQ1','CAGI','InvCFA1','InvCAGI','CFA2','NOI1','InvCFA1'};
success = true;
% indexFile = extractAfter(path,'dev_');

%% Some other shitty file
% if(strcmp(indexFile,'')==true)
%     success = false ;  
%      finalImage = 'KUR';
%      return;
% end

file = strcat('dev_',extractAfter(path,'dev_'));
    
    finalImage = imread(path);
   
    
    extension = extractAfter(file,'.');
    if(strcmp(extension,'jpg'))
        %% THIS IS JPEG FILE run set of algorithms for it
        listOfAlrorithms = jpegList;
    else
        %% THIS IS TIF FILE run set of algorithms for it
        listOfAlrorithms = tifList;
    end
    
    [~,algorithmsSize] = size(listOfAlrorithms);
    valueFound = false;
    for j=1:algorithmsSize
        method = listOfAlrorithms{j};
        im = runAlgorithm(method,path);
%         fprintf('Method used is -> %s\n',method{1});
        % Check the result
        matchValue = evaluateMap(im);
        if(matchValue==true)
           valueFound = true;
           met = method;
           finalImage = im;
           break;
        end
    end
    if(valueFound==false)
        finalImage = im;
        fprintf('LAST METHOD FAILED -- IMPLEMENT MORE | file %s \n', file);
        met = 'NaN';
    end
    