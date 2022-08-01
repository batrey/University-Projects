[X,GrowthRate,ID_index,Strain_index,Medium_index,Environmental_perturbation_index,Gene_Perturbation_index,Medium_Environmental_perturbation] = load_data();

LSL = min(GrowthRate); USL = max(GrowthRate);                     % Process specifications
capable = @(x)(USL-LSL)./(6* std(x));  % Process capability
ci = bootci(length(GrowthRate'),capable,GrowthRate') ;
disp(['Confidence interval: '  num2str(ci(1)) '; '  num2str(ci(2))])