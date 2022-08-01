function [X,GrowthRate,ID_index,Strain_index,Medium_index,Environmental_perturbation_index,Gene_Perturbation_index,Medium_Environmental_perturbation_index] = load_data()
filename = 'ecs171.dataset.csv';
M = readtable(filename);
C = table2cell(M);
Dataset = [];
X = [];
Y = [];
ID = [];
Strain = [];
Medium = [];
Environmental_perturbation = [];
Gene_Perturbation = [];
Medium_Environmental_perturbation = [];

for i = 1:1:length(C)
    T = strsplit(C{i,1},';');
    row = [];
    row_double = [];
    Y = [Y; str2double(T{1,6})];
    %Medium_Environmental_perturbation_row = [T{1,3} T{1,4}];
    for j = 1:1:length(T)
        Medium_Environmental_perturbation_row = '';
        row = [row T(j)];
        switch j
            case 1
                ID = [ID T(j)];
            case 2
                Strain = [Strain T(j)];
            case 3
                Medium = [Medium  T(j)];      
            case 4
                Environmental_perturbation = [Environmental_perturbation T(j)];
            case 5
                Gene_Perturbation = [Gene_Perturbation T(j)];
            otherwise
                t = str2double(T{1,j});
                if(isnan(t))
                    t = 0;
                end
                row_double = [row_double t];
        end;
    end;
    X = [X; row_double];
    t = [T{1,3} T{1,4} ';'];
    
    Medium_Environmental_perturbation = [Medium_Environmental_perturbation   t];
    Dataset = [Dataset;row];
end;
Medium_Environmental_perturbation = strsplit( Medium_Environmental_perturbation,';');

disp(Medium_Environmental_perturbation);
ID_name = unique(ID);
Strain_name = unique(Strain);
Medium_name = unique(Medium);
Environmental_perturbation_name = unique(Environmental_perturbation);
Gene_Perturbation_name = unique(Gene_Perturbation);
Medium_Environmental_perturbation_name = unique(Medium_Environmental_perturbation');
ID_index = zeros(1,length(C));
Strain_index = zeros(1,length(C));
Medium_index = zeros(1,length(C));
Environmental_perturbation_index = zeros(1,length(C));
Gene_Perturbation_index = zeros(1,length(C));
Medium_Environmental_perturbation_index = zeros(1,length(C));
for j = 1:1:length(ID)
    for i = 1:1:length(ID_name)
        if  char(ID(j)) == char(ID_name(i))
            ID_index(j) = i;
        end
    end
    for i = 1:1:length(Strain_name)
        if  strcmp(char(Strain(j)),char(Strain_name(i)))
            Strain_index(j) = i;
        end
    end
    for i = 1:1:length(Medium_name)
        if  strcmp(char(Medium(j)),char(Medium_name(i)))
            Medium_index(j) = i;
        end
    end
    for i = 1:1:length(Environmental_perturbation_name)
        if  strcmp(char(Environmental_perturbation(j)),char(Environmental_perturbation_name(i)))
            Environmental_perturbation_index(j) = i;
        end
    end
    for i = 1:1:length(Gene_Perturbation_name)
        if  strcmp(char(Gene_Perturbation(j)),char(Gene_Perturbation_name(i)))
            Gene_Perturbation_index(j) = i;
        end
    end
    for i = 1:1:length(Medium_Environmental_perturbation_name)
        if  strcmp(char(Medium_Environmental_perturbation(j)),char(Medium_Environmental_perturbation_name(i)))
            Medium_Environmental_perturbation_index(j) = i-1;
        end
    end
    GrowthRate = Y;
end