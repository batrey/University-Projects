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


errorMatrix = [];
for i = 1:1:3
    errorRow = [];
    for j = 3:3:12 
        hidden = [];
        for k = 1:1:i
            hidden = [hidden [j]];
        end
        net = feedforwardnet(hidden);
        net.trainParam.epochs = 100;
        net = init(net);
        [net,tr] = train(net,data_train,names_train);
        errorRow = [errorRow [perform(net,sim(net,data_test),names_test)]];
    end
    errorMatrix = [errorMatrix [errorRow]];
end 
figure;
plot3([1 2 3 1 2 3 1 2 3 1 2 3],[3 3 3 6 6 6 9 9 9 12 12 12],errorMatrix);
figure;
ak = reshape(errorMatrix,[3,4]);
plot([3 6 9 12],[ak(1,:)' ak(2,:)' ak(3,:)']);
legend('1 layer','2 layer','3 layer');
disp(reshape(errorMatrix,[3,4]));