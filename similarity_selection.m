function [X_g,T_g] = similarity_selection(X,P,rho,lambda,C_m)

N = length(P);

Nrho = round(rho*N);

X_p = X(:,P);

if nargin < 5 || isempty(C_m)
    %find the median
    X_m = mean(X_p,2);
else
    %Check if centroid is within the segment. Otherwise, select the 
    %nearest neighbor
    if isempty(find(P==C_m, 1))
        [~,nneighs] = sort(abs(P-C_m));
        C_m = P(nneighs(1));
    end
    X_m = X(:,C_m);
end

X_g = X_m;
T_g = find(P==C_m);

%% Find self-representation per superpixel
T_cost = lasso_cost(X_g,X_p,lambda);

for k=2:Nrho
    
    [~, ord] = sort(T_cost,'descend');
    max_cost = 0;
    max_cost_idx = [];
    for jj = 1:N
        idx = ord(jj);
        if any(T_g == idx)
            T_cost(idx) = 1 - 0.5/lambda;
        else
            T_cost(idx) = lasso_cost(X_g, X_p(:, idx), lambda);
        end
        if T_cost(idx) > max_cost
            max_cost = T_cost(idx);
            max_cost_idx = idx;
        end
        if max_cost >= T_cost(ord(jj + 1))
            break;
        end
    end
    if(~all(max_cost_idx ~= T_g))
       warning('Warning in similarity selection'); 
    end
    T_g = [T_g, max_cost_idx];
    X_g = [X_g, X_p(:, max_cost_idx)];
end
[T_g,sT] = sort(T_g);
X_g = X_g(:,sT);
T_g = P(T_g);
end
