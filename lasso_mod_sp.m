function [T, C] = lasso_mod_sp(X, parameters)
% This codes implements Algorithm 2 of the paper.


Nseg = parameters.Nseg;
tau = parameters.tau;
rho = parameters.rho;
cube_size = parameters.cube_size;

[SPmap, CenT, U, ~, ~] = getSimilarityInfo(X,cube_size,Nseg,true);

[Nseg,~] = size(U);

X_T = [];
T = [];

for seg = 1:Nseg
    [X_g,T_g] = similarity_selection(X,find(U(seg,:)),rho,tau,CenT(seg));
    X_T = [X_T,X_g];
    T = [T,T_g];  
end

cost = lasso_cost(X_T,X,tau);
N=cube_size(1)*cube_size(2);
% selection
while(~isempty(find(cost>=tau/2-0.01, 1)))
    [~, ord] = sort(cost, 'descend');
    max_cost = 0;
    max_cost_idx = [];
    for jj = 1:N 
        idx = ord(jj);
        if any(T == idx)
            cost(idx) = 1 - 0.5/tau; 
        else
            cost(idx) = lasso_cost(X_T, X(:, idx), tau);
        end
        if cost(idx) > max_cost 
            max_cost = cost(idx);
            max_cost_idx = idx;
        end 
        if max_cost >= cost(ord(jj + 1))
            break;
        end 
    end 
    assert(all(max_cost_idx ~= T));
    T = [T, max_cost_idx];
    X_T = [X_T, X(:, max_cost_idx)];
end

k = size(X_T,2);

C(1:k, :) = solve_lasso(X_T, X, tau);
C(1:k, T) = eye(k) * (1-1/tau); 

end
