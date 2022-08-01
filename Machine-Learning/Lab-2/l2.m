[a1,a2,a3,a4,a5,a6,a7,a8,a9,a10] = textread('d:\AWO-131\yeast.data','%s  %f  %f  %f  %f  %f  %f  %f  %f  %s');
data = [a2 a3 a4 a5 a6 a7 a8 a9];
names = unique(a10);
names_index = zeros(1,length(names));
data_all = {};
for i = 1:1:length(a10)
    data_all = [data_all [data(i,1);data(i,2);data(i,3);data(i,4);data(i,5);data(i,6);data(i,7);data(i,8)]];
	for j = 1:1:length(names)
		if  char(names(j)) == char(a10(i))
			names_index(i) = j;
        end
    end
end;
%--------------1---------------
rand_index = randperm(length(a10));
separator = round(length(a10)*0.65);
data_train = {};
names_train = {};
for i = 1:1:separator
    data_train = [data_train [data(i,1);data(i,2);data(i,3);data(i,4);data(i,5);data(i,6);data(i,7);data(i,8)]];
    names_train = [names_train names_index(i)];
end
data_test = {};
names_test = {};
for i = separator+1:1:length(a10)
    data_test = [data_train [data(i,1);data(i,2);data(i,3);data(i,4);data(i,5);data(i,6);data(i,7);data(i,8)]];
    names_test = [names_train names_index(i)];
end

names_index = num2cell(names_index);
net = feedforwardnet();%network;
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


disp('--------------2---------------');
[net,tr] = train(net,data_all,names_index);
disp('Perform: ');
disp(perform(net,sim(net,data_all),names_index));
disp('Weights');
disp(getwb(net));
figure
plotwb(net);