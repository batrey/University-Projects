[X,GrowthRate,ID_index,Strain_index,Medium_index,Environmental_perturbation_index,Gene_Perturbation_index,Medium_Environmental_perturbation] = load_data();
X_f_SVM = [];
for i = 1:1:500
    X_f_SVM = [X_f_SVM X(:,i)];
end 

targets = [Strain_index' Environmental_perturbation_index' Gene_Perturbation_index'  Medium_index'];
targets_name = {'Strain' 'Environmental perturbation' 'Gene Perturbation'  'Medium' };
for i = 1:1:4
    SVMModel = fitcecoc(X_f_SVM,targets(:,i)); 
    CVSVMModel = crossval(SVMModel);
    
    TrainedModel = CVSVMModel.Trained{1};
    [label,Score] = predict(SVMModel,X_f_SVM);
    classLoss = kfoldLoss(CVSVMModel);
    disp(targets_name(i));
    disp(['Cross-validation loss: ' num2str(classLoss)]);
    [X_P,Y,T,AUC,OPTROCPT,SUBY,SUBYNAMES]  = perfcurve(label, Score(:,1), 1);
    figure;
    plot(X_P,Y)
    ylim([0 1.05]);
    xlim([-0.05 1.05]);
    xlabel('False positive rate');
    ylabel('True positive rate');
    title([targets_name(i) ' - ROC (AUC: ' num2str(AUC) ')']);
    figure;
    [Xpr,Ypr,Tpr,AUCpr] = perfcurve(label, Score(:,1), 1, 'xCrit', 'reca', 'yCrit', 'prec');
    plot(Xpr,Ypr)
    ylim([0 1.05]);
    xlim([-0.05 1.05]);
    xlabel('Recall'); ylabel('Precision')
    title([targets_name(i) ' - Precision-recall curve (AUC: ' num2str(AUCpr) ')'])
end
