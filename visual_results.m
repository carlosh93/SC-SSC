% This code generates the visual results presented in the paper for all datasets

clear all
close all
clc

addtoPath


k=1;

for Fname = ["Indian_Full","Indian_subset","SalinasA","zurich","paviaU_subset2"]
    
    
    load(Fname);
    
    switch(Fname)
        case 'Indian_Full'
            hyperimg = indian_pines_corrected;
            labels = indian_pines_gt(:)';
            labels = fix_labels(labels);
            clear indian_pines_corrected indian_pines_gt;
            
            database_name = "Indian Full";
            cmp = zeros(256, 3);
            
            cmp(2, :) = [239 228 173]./255; % Alfalfa
            cmp(3, :) = [0,70,203]./255;   % corn-notill
            cmp(4, :) = [229 92 13]./255;  % corn-mintill
            cmp(5, :) = [135 97 236]./255;  % corn
            cmp(6, :) = [224 111 251]./255;  % grass-pasture
            cmp(7, :) = [100 99 253]./255;  % grass-trees
            cmp(8, :) = [140 100 246]./255;  % grass-pasture-mowed
            cmp(9, :) = [138,236,32]./255;  % Hay-windrowed
            cmp(10, :) = [104,139,13]./255;  % Oats
            cmp(11, :) = [167,115,211]./255;  % Soybean-notill
            cmp(12, :) = [66,153,253]./255;  % Soybean-mintill
            cmp(13, :) = [109,123,143]./255;  % Soybean-clean
            cmp(14, :) = [170,193,56]./255;  % wheat
            cmp(15, :) = [121,64,4]./255;  % woods
            cmp(16, :) = [134,237,154]./255;  % bulding-grass-trees-drives
            cmp(17, :) = [240,227,31]./255;  % Stone-Stell-Towers
            
            %select the results to show
            load('Results/Precomputed_Results/best_Indian_Full_Result.mat');
            
            
            
        case 'SalinasA'
            hyperimg = salinasA_corrected(:,1:83,:);
            labels = salinasA_gt(:,1:83);
            labels = labels(:)';
            labels = fix_labels(labels);
            clear salinasA_corrected
            
            cmp = zeros(256, 3);
            
            cmp(2, :) = [0,0,0.749019607843137]; % Brocoli_green_weeds_1
            cmp(3, :) = [1,1,0];   % corn_senesced_green_weeds
            cmp(4, :) = [1,0.749019607843137,0];  %lettuce_romaine_4wk
            cmp(5, :) = [1,0.501960784313726,0];  %lettuce_romaine_5wk
            cmp(6, :) = [1,0.250980392156863,0];  %lettuce_romaine_6wk
            cmp(7, :) = [1,0,0];  %lettuce_romaine_7wk
            
            database_name = "Salinas ROI";
            %select the results to show
            load('Results/Precomputed_Results/best_SalinasA_Result.mat');
            
        case 'Indian_subset'
            hyperimg = Indian_subset;
            labels = gt(:)';
            labels = fix_labels(labels);
            clear Indian_subset gt;
            
            cmp = zeros(256, 3);
            cmp(2, :) = [0 0 255]./255; % Corn-notill (#2)
            cmp(3, :) = [0 255 255]./255;   % Grass-trees (#6)
            cmp(4, :) = [255 255 0]./255;  % Soybean-notill (#10)
            cmp(5, :) = [255 191 0]./255;  % Soybean-mintill (#11)
            
            database_name = "Indian Pines ROI";
            %select the results to show
            load('Results/Precomputed_Results/best_Indian_subset_Result.mat');
            
        case 'zurich'
            hyperimg = IMe(511:660,395:544,:);
            labels = GT(511:660,395:544);
            labels = fix_labels(labels);
            clear IMe IM GT;
            
            cmp = zeros(256, 3); %background
            cmp(2,:) = [100 100 100]./255; % Roads
            cmp(3,:) = [255 120 0]./255; % Buildings
            cmp(4,:) = [0 125 0]./255;  % Trees
            cmp(5,:) = [ 0 255 0]./255; % Grass
            cmp(6,:) = [255 255 0]./255;%Railways
            
            database_name = "Zurich ROI";
            %select the results to show
            load('Results/Precomputed_Results/best_zurich_Result.mat');
            
        case 'paviaU_subset2'
            hyperimg = paviaU;
            labels = paviaU_gt;
            labels = labels(:)';
            labels = fix_labels(labels);
            clear paviaU
            
            load('PaviaU_color');
            
            database_name = "Univ. Pavia ROI";
            %select the results to show
            load('Results/Precomputed_Results/best_paviaU_subset2_Result.mat');
    end
    
    [Mc,Nc,L] = size(hyperimg);
    
    titlerstl=[database_name,' OA: ',num2str(rstl.acc_o*100,'%2.2f')];
    
    % Ground-Truth
    
    subplot(2,5,k);
    image(reshape(labels,[Mc Nc])); colormap(gca,cmp);
    title('GroudTruth');
    axis off
    
    
    results = reshape(rstl.groups,[Mc Nc]);
    results(labels==1)=1;
    subplot(2,5,5+k);
    image(results); colormap(gca,cmp)
    title(titlerstl);
    axis off
    
    
    k = k + 1;
end

sgtitle('Land Cover Maps using SC-SSC')