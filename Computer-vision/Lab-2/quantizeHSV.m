function [outputImg, meanHues] = quantizeHSV(origImg, k)

HSVimg = rgb2hsv(origImg);
[m,n,~] = size(origImg);
numpixels = m * n;
X = reshape(HSVimg, numpixels, 3);
[idx,C] = kmeans(X(:,1),k);

for i = 1:numpixels
    X(i,1) = C(idx(i,1),:);
end

X = reshape(X,m,n,3);
outputImg = hsv2rgb(X);
outputImg = round(outputImg * 255);
outputImg = uint8(outputImg);
meanHues = C;
end