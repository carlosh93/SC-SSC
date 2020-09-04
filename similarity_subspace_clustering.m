function [groups,time] = similarity_subspace_clustering(X, nCluster, parameters)
% This codes implements Algorithm 2 of the paper.

% Input Arguments
% X                 -- matrix of D by N where each column is a spectral signature.
% nCluster          -- number of clusters.
% parameters        -- structure with parameters E, rho, Ks and tau


tic;
[~, C0] = lasso_mod_sp(X, parameters);

C0 = full(C0);

%New Fast Spectral Clustering

groups = FastSpectralClustering(C0, nCluster, parameters.k_size, 'Eig_Solver', 'eigs','Kmeans_Solver', 'vl_kmeans');

time=toc;
end
