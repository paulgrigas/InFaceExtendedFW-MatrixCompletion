function [away_direction, direction_params, alpha_full, alpha_partial, away_wolfe_neg, interior_warm_flag] = prox_grad_simplex(Zk, grad_vec, irow, jcol, delta, options)
% Current status: correct Lipschitz bound and doubling strategy ONLY implemented for entropy, not Euclidean
%
%Input: Zk, grad_vec represent the current point
%       Omega, X_obs_vec, delta describe the instance
%Output: away_direction is the away step
%        alpha_full is the maximum step-size to the relative boundary
%        alpha_partial is a partial line-search step-size
%        away_wolfe_neg is a quantity needed for GM decision rule, see paper
%        interior_warm_flag is whether Zk is on the interior of the nuclear norm ball, not relevant here

interior_warm_flag = 0;
r = length(Zk.d);
if r <= 1
    away_direction = zeros(length(irow), 1);
    direction_params = struct();
    alpha_full = 0;
    alpha_partial = 0;
    away_wolfe_neg = 0;
    return;
end

% DO PROX GRADIENT
nuc_norm = sum(Zk.d);
U = nuc_norm*Zk.U; % standardize simplex
V = Zk.V;
r = length(Zk.d);
no_obs = length(irow);
X_obs_vec = Zk.vec - grad_vec;

% compute Lipschitz constant for ell_1 / entropy case (Lipschitz is ONLY implemented for this case now)
% L_ell1 = 0;
% for k = 1:r
%     cur_norm = norm(U(:,k), 2)*norm(V(:,k), 2);
%     if cur_norm > L_ell1
%         L_ell1 = cur_norm;
%     end
% end
% L_ell1 = L_ell1^2; % = delta^2 as long as we are normalized
if options.prox_grad_doubling == 1
    L_ell1 = 1;
else
    L_ell1 = nuc_norm^2;
end


% current iterate
d_cur = Zk.d/nuc_norm; % our current iterate, standardize the simplex

% current Z
Zvec_cur = Zk.vec;
objval_old = Inf;

% for dual stuff
g_avg = 0;
dual_lower_bound = 0;
dual_lower_bound_terms = 0; % avg of f(x_i) - dot(gradf(x_i), x_i)

not_monotone_flag = 0;

% needed for first iteration of loop
grad_vec_cur = Zvec_cur - X_obs_vec;
objval_new = .5*norm(grad_vec_cur, 2)^2;

for k = 1:options.prox_grad_iters
    % do convergence test
    %current_rel_gap = (objval_old - objval_new)/objval_new
    
    if options.prox_grad_dual_stop == 1
        prox_gap = objval_new - dual_lower_bound;
        if prox_gap < options.prox_grad_tol
            final_prox_gap = prox_gap
            total_inner_prox_iters = k - 1;
            break;
        end
    elseif objval_old < objval_new - options.prox_grad_tol    
        not_monotone_flag = 1;
    elseif (objval_old - objval_new)/objval_new < options.prox_grad_tol
        total_inner_prox_iters = k - 1;
        break;
    end
    
    if k == options.prox_grad_iters
        total_inner_prox_iters = k;
    end
    
    
    objval_old = objval_new;

    % compute gradient
    grad_cur = sparse(irow, jcol, grad_vec_cur);
    g_cur = diag(V'*grad_cur'*U);

    % update average and dual lower bound
    g_avg = ((k-1)/k)*g_avg + (1/k)*g_cur;
    new_lb_terms = objval_new - g_cur'*d_cur;
    dual_lower_bound_terms = ((k-1)/k)*dual_lower_bound_terms + (1/k)*new_lb_terms;

    d_g = min(g_avg);
    dual_lower_bound = new_lb_terms + d_g;        

    % do either Euclidean or entropy projection step
    if options.prox_grad_simplex_euclidean == 1
        grad_step = d_cur - g_cur;
        d_cur = proj_unit_simplex(grad_step);
    else
        % do entropy projection step
        % gradient of entropy at the current point
        
        doubling_continue = 1;
        
        while doubling_continue
            d_new = entropy_projection(d_cur, g_cur, L_ell1);
            
            % determine Zvec and proposed objective value 
            left_new = U*diag(d_new);
            Zvec_new = project_obs_UV(left_new, V, irow, jcol, no_obs);
            grad_vec_new = Zvec_new - X_obs_vec;
            objval_new = .5*norm(grad_vec_new, 2)^2;
            
            if options.prox_grad_doubling == 1
                ineq_right = objval_old + g_cur'*(d_new - d_cur) + (L_ell1/2)*norm(d_new - d_cur, 1)^2;
                ineq_val = ineq_right - objval_new;
                if ineq_val >= 0
                    doubling_continue = 0;
                    L_ell1 = (1/2)*L_ell1; % allows us to search for lower values of L_ell1
                else
                    doubling_continue = 1;
                    L_ell1 = 2*L_ell1;
                end
            else
                % not doing doubling 
                doubling_continue = 0;
            end
        end
    end
    
    % update point/gradient/objval for next iteration
    if options.prox_grad_simplex_euclidean == 1
        % determine Zvec_cur
        left_cur = U*diag(d_cur);
        Zvec_cur = project_obs_UV(left_cur, V, irow, jcol, no_obs);
        grad_vec_cur = Zvec_cur - X_obs_vec;
        objval_new = .5*norm(grad_vec_cur, 2)^2;
    else
        d_cur = d_new;
        Zvec_cur = Zvec_new;
        grad_vec_cur = grad_vec_new;
        % objval_new already set
    end
end

away_direction = Zvec_cur - Zk.vec;
direction_params = struct(); 
direction_params.update_type = 'weights_general';
direction_params.Delta = nuc_norm*diag(d_cur) - diag(Zk.d);
direction_params.new_weights = nuc_norm*d_cur;

alpha_full = 1;
alpha_partial = 1;
away_wolfe_neg = grad_vec'*away_direction;

direction_params.not_monotone_flag = not_monotone_flag;
direction_params.total_inner_prox_iters = total_inner_prox_iters;

end