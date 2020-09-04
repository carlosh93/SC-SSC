function cost = lasso_cost(X, Y, lambda)
    C = solve_lasso(X, Y, lambda);
    R = Y - X * C;
    cost = sum(abs(C), 1) + lambda / 2 * sum(R .^2, 1);
end