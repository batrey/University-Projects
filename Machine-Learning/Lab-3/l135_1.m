[X,GrowthRate,ID_index,Strain_index,Medium_index,Environmental_perturbation_index,Gene_Perturbation_index,Medium_Environmental_perturbation] = load_data();

net = feedforwardnet();
net.numInputs = 1;
net.numLayers = 3;
net.inputConnect = [1 ;0; 0];
net.layerConnect = [0 0 0; 1 0 0; 0 1 0];
net.outputConnect = [0 0 1];
net.layers{1}.size = 3;
net.layers{2}.size = 3;
net.trainFcn = 'traingd';
net.trainParam.epochs = 100;
net = init(net);
[net,tr] = train(net,X',GrowthRate');
hold on;
plotperform(tr);
figure
plottrainstate(tr);
figure
y = net(X');
plotregression(GrowthRate',y,'Regression')
[B, FitInfo] = lasso(X,GrowthRate,'CV',10);
lassoPlot(B,FitInfo,'PlotType','CV');
disp(['10-fold cross-validation generalization error '  num2str(mean(FitInfo.MSE))]);
disp(['Number of features that have non-zero coefficients '  num2str(sum(FitInfo.DF))]);