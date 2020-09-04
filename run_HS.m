%  This code tests the performance of the proposed subspace clustering algorithm for land cover
%  segmentation. This code generate individual results for each dataset

% Dependencies:
% - Databases: In this work we use four different databases: Indian Pines, Salinas, University of
%       Pavia and Zurich. The first three are well-known and challenged hyperspectral images used
%       for land cover segmentation and are freely available at: http://www.ehu.eus/ccwintco/index.php/Hyperspectral_Remote_Sensing_Scenes

%    The zurich dataset was first used in the work:
%    Volpi, M. & Ferrari, V.; Semantic segmentation of urban scenes by learning local class  interactions, In IEEE CVPR 2015 Workshop "Looking from above: when Earth observation meets vision" (EARTHVISION), Boston, USA, 2015.

%    and can be downloaded from: https://sites.google.com/site/michelevolpiresearch/data/zurich-dataset
% We provide these databases in the folder Data, but all the credits must be given to the corresponding 
% works shown above.

close all
clear all
clc

%% DataPath

addtoPath;

%% Loading Data
% Uncomment one of the data set below
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
        % Settings
        [Mc,Nc,L] = size(hyperimg);
        parameters.cube_size = [Mc,Nc,L];
        parameters.rho = 0.35;  % pixels in the superpixel
        parameters.tau = 5;% tau in the representation cost function
        parameters.Nseg = 1700; % Number of superpixels
        parameters.k_size = 8; % Kernel size in Fast Spectral Clustering
        
    case 'SalinasA'
        hyperimg = salinasA_corrected(:,1:83,:);
        labels = salinasA_gt(:,1:83);
        labels = labels(:)';
        labels = fix_labels(labels);
        clear salinasA_corrected
        % Settings
        [Mc,Nc,L] = size(hyperimg);
        parameters.cube_size = [Mc,Nc,L];
        parameters.rho = 0.2;  % pixels in the superpixel
        parameters.tau = 20;% tau in the representation cost function
        parameters.Nseg = 700; % Number of superpixels
        parameters.k_size = 3; % Kernel size in Fast Spectral Clustering
        
    case 'paviaU_subset2'
        hyperimg = paviaU;
        labels = paviaU_gt;
        labels = labels(:)';
        labels = fix_labels(labels);
        clear paviaU
        % Settings
        [Mc,Nc,L] = size(hyperimg);
        parameters.cube_size = [Mc,Nc,L];
        parameters.rho = 0.3;  % pixels in the superpixel
        parameters.tau = 20;% tau in the representation cost function
        parameters.Nseg = 1900; % Number of superpixels
        parameters.k_size = 8; % Kernel size in Fast Spectral Clustering
        
    case 'Indian_Full'
        hyperimg = indian_pines_corrected;
        labels = indian_pines_gt(:)';
        labels = fix_labels(labels);
        clear indian_pines_corrected;
        % Settings
        [Mc,Nc,L] = size(hyperimg);
        parameters.cube_size = [Mc,Nc,L];
        parameters.rho = 0.25;  % pixels in the superpixel
        parameters.tau = 5;% lambda in the representation cost function
        parameters.Nseg = 900; % Number of superpixels
        parameters.k_size = 8; % Kernel size in Fast Spectral Clustering
        
    case 'zurich'
        hyperimg = double(IMe(511:660,395:544,:)); %Selecting ROI
        labels = GT(511:660,395:544);%Selecting ROI
        labels = labels(:)';
        labels = fix_labels(labels);
        clear IMe IM;
        % Settings
        [Mc,Nc,L] = size(hyperimg);
        parameters.cube_size = [Mc,Nc,L];
        parameters.rho = 0.35;  % pixels in the superpixel
        parameters.tau = 5;% tau in the representation cost function
        parameters.Nseg = 1900; % Number of superpixels
        parameters.k_size = 8; % Kernel size in Fast Spectral Clustering
        
end


%% Testing
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
fprintf('Overall Accuracy: %f , NMI: %f, Time: %f \n', rstl.acc_o*100, rstl.nmi,rstl.time)
