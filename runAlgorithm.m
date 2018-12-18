function [binaryIm] = runAlgorithm(alg,path)
OutputMap2 = zeros(1500,2000);
duelMode = false;
complm=0;
switch(alg)
    case 'ADQ1'
        [OutputMap1, ~, ~] = analyzeADQ1(path);
    case 'CFA1'
        [OutputMap1] = analyzeCFA1(path);
    case 'DCT'
        [OutputMap1] = analyzeDCT(path);
    case 'NADQ'
        OutputMap1 = analyzeNADQ(path);
    case 'NOI1'
        OutputMap1 = analyzeNOI1(path);
    case 'GHO'
        [OutputMap1] = analyzeGHO(path);
    case 'ADQ2|ADQ1'
        duelMode = true;
        [OutputMap1] = analyzeADQ2(path);
        [OutputMap2, ~, ~] = analyzeADQ1(path);
    case 'DCT|CAGI'
        duelMode = true;
        [OutputMap1] = analyzeDCT(path);
        [OutputMap2, ~] = CAGI(path);
    case 'ADQ1|CAGI'
        duelMode = true;
        [OutputMap1, ~, ~] = analyzeADQ1(path);
        [OutputMap2, ~] = CAGI(path);
    case 'InvCAGIx'
        [~,OutputMap1 ] = CAGI(path);
        complm = 1;
    case 'CAGI'
        [OutputMap1,~] = CAGI(path);
    case 'InvCFA1'
        [OutputMap1] = analyzeCFA1(path);
        complm = 1;
    otherwise
        [OutputMap1] = analyzeDCT(path);
end



if complm == 1
    binaryIm = OutputMap1;
    binaryIm=imbinarize(im2uint8(binaryIm));
    binaryIm = imcomplement(binaryIm);
    binaryIm=imfill(binaryIm, 'holes');
    binaryIm=(imresize(binaryIm,[1500 2000])); % cagi does not need it but others do
    
else
    OutputMap1=imbinarize(OutputMap1);
    OutputMap1 = imclose(bwareafilt(OutputMap1,1), ones(20));
    OutputMap1 = imfill(OutputMap1, 'holes');
    OutputMap1=(imresize(OutputMap1,[1500 2000]));
    
    binaryIm = OutputMap1;
    binaryIm=imbinarize(im2uint8(binaryIm));
    binaryIm=imfill(binaryIm, 'holes');
end
if(duelMode == true)
    OutputMap2=imbinarize(OutputMap2);
    OutputMap2 = imclose(bwareafilt(OutputMap2,1), ones(20));
    OutputMap2 = imfill(OutputMap2, 'holes');
    OutputMap2=(imresize(OutputMap2,[1500 2000]));
    
    binaryIm = imfuse(OutputMap1,OutputMap2);
    binaryIm=imbinarize(rgb2gray(binaryIm));
    binaryIm=imfill(binaryIm, 'holes');    
end

