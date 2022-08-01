function [error] = computeQuantizationError(origImg,quantizedImg)

error = 0;
origImg = double(origImg);
quantizedImg = double(quantizedImg);
distances = (origImg - quantizedImg).^2;

[m,n,l] = size(distances);
for i = 1:m
    for j = 1:n
        for k = 1:l
            error = error + distances(i,j,k);
        end
    end
end

end