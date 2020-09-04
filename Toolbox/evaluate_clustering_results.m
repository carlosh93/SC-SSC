function rstl = evaluate_clustering_results(labs_est, labs)
% Evaluate Classification Results
%
% Syntax:
%       [kappa acc acc_O acc_A] = evaluate_results(tlabs, Trlabs)
%
% Input:
%       labs_est:  M-by-1 vector of labels given to test data
%       labs    : M-by-1 vector of ground truth labels
%
% Output:
%       kappa:  kappa coefficient
%       acc:    accuracy per class
%       acc_o:  overall accuracy
%       acc_a:  average accuracy
% 

%The background is not taken into account as a class, hence it is removed
%from the results calculation


nc = unique(labs);
nc(nc==nc(1))=[]; %not take into account the background
c = length(nc);
% make confusion matrix

CM = zeros(c,c);

for i = 1:c
    for j = 1:c
        CM(i,j) = sum(labs_est==nc(i) & labs==nc(j));
    end
end

% Class accuracy
p_acc = zeros(c, 1);
u_acc = zeros(c, 1);
for j = 1:c
    %Producer's accuracy
    p_acc(j) = CM(j,j)/sum(CM(:,j));
    %User's accuracy
    u_acc(j) = CM(j,j)/sum(CM(j,:));
end

% Overall and average accuracy
acc_o = sum(diag(CM))/sum(sum(CM));
acc_a = mean( p_acc );

% Kappa coefficient of agreement
kappa = (acc_o - sum( sum(CM,1)*sum(CM,2) )/sum(sum(CM)).^2)...
           /(1 - sum( sum(CM,1)*sum(CM,2) )/sum(sum(CM)).^2);

% F Measure
labs_est(labs==1)=[];
labs(labs==1)=[];
try
[Fmeasure,~] = evalFmeasure(labs, labs_est);
catch
    warning('No Fmeasure results');
    Fmeasure = 0;
end
% NMI 
NMI_measure = nmi(labs,labs_est);

%collect all results
rstl.p_acc   = p_acc;
rstl.u_acc   = u_acc;
rstl.acc_o = acc_o;
rstl.acc_a = acc_a;
rstl.kappa = kappa;
rstl.Fmeasure = Fmeasure;
rstl.nmi = NMI_measure;

end


