%  This code finds the parameters that provide the best results in terms of Overall accuracy.

close all
clear all
clc

%% DataPath

addtoPath;

%% Loading Data
Fname = 'Indian_subset';
% Fname = 'SalinasA';
% Fname = 'paviaU_subset2';
% Fname = 'Indian_Full';
% Fname = 'zurich';

load(Fname);

switch(Fname)
    case 'Indian_subset'
        hyperimg = Indian_subset;
        labels = gt(:)';
        labels = fix_labels(labels);
        clear Indian_subset;
        
    case 'Indian_subset2'
        labels = hyperimg_gt(:)';
        labels = fix_labels(labels);
        
        
    case 'SalinasA'
        hyperimg = salinasA_corrected(:,1:83,:);
        labels = salinasA_gt(:,1:83);
        labels = labels(:)';
        labels = fix_labels(labels);
        clear salinasA_corrected
        
        
    case 'paviaU_subset2'
        hyperimg = paviaU;
        labels = paviaU_gt;
        labels = labels(:)';
        labels = fix_labels(labels);
        clear paviaU
        
        
    case 'Indian_Full'
        hyperimg = indian_pines_corrected;
        labels = indian_pines_gt(:)';
        labels = fix_labels(labels);
        clear indian_pines_corrected;
        
    case 'zurich'
        hyperimg = double(IMe(511:660,395:544,:));
        labels = GT(511:660,395:544);
        labels = labels(:)';
        labels = fix_labels(labels);
        clear IMe IM;
end


[Mc,Nc,L] = size(hyperimg);
parameters.cube_size = [Mc,Nc,L];


bestRstlbyOA = [];
bestRstlbyNMI = [];
bestOA = 0;
bestNMI = 0;


%% Parameters Tunning

tauV = 5:5:20;
rhoV = [0.2,0.25,0.3,0.35];
NsegV = 100:200:2000;
k_sizeV = [3,5,8,16];

for tau=tauV
    for rho = rhoV
        for Nseg = NsegV
            for k_size = k_sizeV
                
                parameters.rho = rho;  
                parameters.tau = tau;
                parameters.Nseg = Nseg; 
                parameters.k_size = k_size; 
                
                data = reshape(hyperimg,Mc*Nc,L);
                data = data';
                
                [D,N] = size(data);
                
                nCluster = length(unique(labels))-1;
                
                %% Preprocessing %
                if L*0.25>3
                    data = dimReduction(data,floor(L*0.25)); % dimension reduction by PCA
                end
                data = bsxfun(@minus, data, mean(data, 2)); % mean subtraction
                data = cnormalize_inplace(data);
                %% Clustering
                [groups,time] = similarity_subspace_clustering(data, nCluster, parameters);
                [groups] = bestMapHS(groups,labels);
                %% Evaluation
                [rstl] = evaluate_clustering_results(groups,labels);
                rstl.time = time;
                rstl.groups = groups;
                rstl.parameters = parameters;
                
                if rstl.acc_o > bestOA
                    bestOA = rstl.acc_o;
                    bestRstlbyOA = rstl;
                end
                
                
                if rstl.nmi > bestNMI
                    bestNMI = rstl.nmi;
                    bestRstlbyNMI = rstl;
                end
                
                %% Save Results
                if ~(exist(fullfile(cd, ['Results/',Fname]), 'file') == 7)
                    mkdir(['Results/',Fname])
                end
                save(['Results/',Fname,'/',Fname,'_la=',num2str(tau),...
                    '_rho=',num2str(rho),'_Nseg=',num2str(Nseg),...
                    '_ksize=',num2str(k_size),'.mat'],'rstl');
            end
        end
    end
end
