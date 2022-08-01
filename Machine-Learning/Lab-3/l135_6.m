[X,GrowthRate,ID_index,Strain_index,Medium_index,Environmental_perturbation_index,Gene_Perturbation_index,Medium_Environmental_perturbation] = load_data();
PCA = pca(X);
PCA_mean = [];
for i = 1:1:length(PCA)
    PCA_mean = [PCA_mean mean(PCA(i,:))];
end
PCA_mean_sort = sort(PCA_mean);
c1 = 0;
c2 = 0;
c3 = 0;
for i = 1:1:length(PCA)
    if PCA_mean(i)== PCA_mean_sort(1)
        c1 = i;
    end
    if PCA_mean(i)== PCA_mean_sort(2)
        c2 = i;
    end
    if PCA_mean(i)== PCA_mean_sort(3)
        c3 = i;
    end
end
X_PCA = [X(:,c1) X(:,c2) X(:,c3)];

targets = [Medium_index' Environmental_perturbation_index'];
targets_name = {'Medium' 'Environmental perturbation'};
for i = 1:1:2
    disp(targets_name(i));
    SVMModel = fitcecoc(X_PCA,targets(:,i));
    CVSVMModel = crossval(SVMModel);
    TrainedModel = CVSVMModel.Trained{1};
    [label,Score] = predict(SVMModel,X_PCA);
    classLoss = kfoldLoss(CVSVMModel);
    disp(['Cross-validation loss: ' num2str(classLoss)]);
    [X_P,Y,T,AUC,OPTROCPT,SUBY,SUBYNAMES]  = perfcurve(label, Score(:,1), 1);
    figure;
    plot(X_P,Y)
    xlabel('False positive rate');
    ylabel('True positive rate');
    title([targets_name(i) ' - ROC (AUC: ' num2str(AUC) ')']);
    figure;
    [Xpr,Ypr,Tpr,AUCpr] = perfcurve(label, -Score(:,1), 1, 'xCrit', 'reca', 'yCrit', 'prec');
    plot(Xpr,Ypr)
    xlabel('Recall'); ylabel('Precision')
    title([targets_name(i) ' - Precision-recall curve (AUC: ' num2str(AUCpr) ')'])
end
