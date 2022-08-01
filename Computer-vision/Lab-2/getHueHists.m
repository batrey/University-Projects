function [histEqual, histClustered] = getHueHists(im, k)

HSVimg = rgb2hsv(im);
[m,n,~] = size(im);
numpixels = m * n;
HSVimg = reshape(HSVimg, numpixels, 3);
[idx,C] = kmeans(HSVimg(:,1),k);

for i = 1:numpixels
    idx(i,1) = C(idx(i,1),:);
end

C = sort(C);

histEqual = hist(idx,k);
hist(idx,k)
histClustered = hist(idx,C);
end