function [outputImg, meanColors] = quantizeRGB(origImg, k)

[m,n,~] = size(origImg);
numpixels = m * n;
origImg = im2double(origImg);
X = reshape(origImg, numpixels, 3);

[idx,C] = kmeans(X,k);

for i = 1:numpixels
    X(i,:) = C(idx(i,1),:);
end

outputImg = reshape(X,m,n,3);
outputImg = round((outputImg * 255),0);
outputImg = uint8(outputImg);
meanColors = C;
end