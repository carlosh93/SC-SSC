function groups = FastSpectralClustering(W, n,k_size, varargin) 
%Fast SPECTRALCLUSTERING Spectral clustering.

% Input Arguments
% W                -- affinity matrix.
% n                -- number of groups.
% k_size           -- Kernel size (K_s)

% Set default 
vararg = {'Start', 'sample', ...
          'MaxIter', 1000, ...
          'Replicates', 20, ...
          'Eig_Solver', 'eig', ...
          'Kmeans_Solver', 'kmeans'}; % kmeans or vl_kmeans
          
% Overwrite by input
vararg = vararginParser(vararg, varargin);
% Generate variables
for pair = reshape(vararg, 2, []) % pair is {propName;propValue}
   eval([pair{1} '= pair{2};']);
end


[W] = enforce_similarity(W,k_size);
W = cnormalize_inplace(W);
alpha = sum(W,2);
D = diag(W'*alpha);
new_W = W/sparse(D);

[~,~,kerN] = svds(cnormalize(new_W,1),n);

kerN = cnormalize_inplace(kerN')';
if strcmpi(Kmeans_Solver, 'kmeans')
    groups = kmeans(kerN, n, 'Start', Start, ...
                             'MaxIter', MaxIter, ...
                             'Replicates', Replicates, ...
                             'EmptyAction', 'singleton');
elseif strcmpi(Kmeans_Solver, 'vl_kmeans') 
    [~, groups] = vl_kmeans(kerN', n, 'Initialization', 'PLUSPLUS', ...
                         'Algorithm', 'LLOYD', ...
                         'NumRepetitions', Replicates);             
end

end
