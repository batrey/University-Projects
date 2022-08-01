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


disp('--------------5---------------');
net = feedforwardnet([12 12 12]);
net.trainParam.epochs = 100;
net = init(net);
[net,tr] = train(net,data_train,names_train);
disp('0.5;0.49;0.52;0.2;0.55;0.03;0.5;0.39');
disp('Is');
disp(names(round(sim(net,[0.5;0.49;0.52;0.2;0.55;0.03;0.5;0.39]))));