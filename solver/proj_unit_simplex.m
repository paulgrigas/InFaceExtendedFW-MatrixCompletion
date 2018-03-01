function w = proj_unit_simplex(v)
    % returns the projection of v onto the unit simplex
    % i.e. solution to min_w .5*\|w - v\|_2^2 s.t. \sum_{i = 1}^n w_i = 1, w >= 0
    % Algorithm from Duchi et al. 2008
    n = length(v);
    mu = sort(v, 'descend');
    
    % find rho
    current_sum = 0;
    current_rho_sum = 0;
    current_rho = 0;
    for j = 1:n
        current_sum = current_sum + mu(j);
        current_rho_val = mu(j) - (1/j)*(current_sum - 1);
        if current_rho_val > 0
            current_rho = j;
            current_rho_sum = current_rho_sum + mu(j);
        else
            break;
        end
    end
    rho = current_rho;
    rho_sum = current_rho_sum;
    
    theta = (1/rho)*(rho_sum - 1);
    w = max(v - theta, 0);
end