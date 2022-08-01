[X,GrowthRate,ID_index,Strain_index,Medium_index,Environmental_perturbation_index,Gene_Perturbation_index,Medium_Environmental_perturbation] = load_data();
X_f_SVM = [];
for i = 1:1:100
    X_f_SVM = [X_f_SVM X(:,i)];
end 
C_T = Medium_Environmental_perturbation;



targets = [Medium_Environmental_perturbation' Medium_index' Environmental_perturbation_index' ];
targets_name = {'Composite' 'Medium' 'Environmental perturbation' };
for i = 1:1:3
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


%SVMModel = fitcecoc(X_f_SVM,C_T);
%CVSVMModel = crossval(SVMModel);
%TrainedModel = CVSVMModel.Trained{1};
%[label,Score] = predict(TrainedModel,X_f_SVM);
%classLoss = kfoldLoss(CVSVMModel);
%disp(['Composite cross-validation loss: ' num2str(classLoss)]);
%[X_P,Y,T,AUC,OPTROCPT,SUBY,SUBYNAMES]  = perfcurve(label, Score(:,1), 1);
%plot(X_P,Y)
%xlabel('False positive rate');
%ylabel('True positive rate');
%title(['ROC (AUC: ' num2str(AUC) ')']);
%figure;
%[Xpr,Ypr,Tpr,AUCpr] = perfcurve(label, Score(:,1), 1, 'xCrit', 'reca', 'yCrit', 'prec');
%plot(Xpr,Ypr)
%xlabel('Recall'); ylabel('Precision')
%title(['Precision-recall curve (AUC: ' num2str(AUCpr) ')'])
