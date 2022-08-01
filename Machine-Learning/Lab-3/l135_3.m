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
X_mean = [];
for i = 1:1:length(X(1,:))
    X_mean = [X_mean; mean(X(:,i))];
end
GR = sim(net,X_mean);
disp(['GrowthRate: ' num2str(GR)]);