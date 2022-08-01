origImg = imread('fish.jpg');

[outputImg1, meanColors5] = quantizeRGB(origImg, 5)
[error1] = computeQuantizationError(origImg,outputImg1);

[outputImg2, meanHues5] = quantizeHSV(origImg, 5)
[error2] = computeQuantizationError(origImg,outputImg2);

[outputImg3, meanColors25] = quantizeRGB(origImg, 25)
[error3] = computeQuantizationError(origImg,outputImg3);

[outputImg4, meanHues25] = quantizeHSV(origImg, 25);
[error4] = computeQuantizationError(origImg,outputImg4)

[histEqual5, histClustered5] = getHueHists(origImg, 5);
[histEqual25, histClustered25] = getHueHists(origImg, 25);

subplot(2,2,1)
imshow(outputImg1)
title('RGB quantized, k = 5')
subplot(2,2,2)
imshow(outputImg2)
title('HSV quantized, k = 5')
subplot(2,2,3)
imshow(outputImg3)
title('RGB quantized, k = 25')
subplot(2,2,4)
imshow(outputImg4)
title('HSV quantized, k = 25')