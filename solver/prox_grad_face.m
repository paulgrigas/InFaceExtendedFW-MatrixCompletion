function [away_direction, direction_params, alpha_full, alpha_partial, away_wolfe_neg, interior_warm_flag] = prox_grad_face(Zk, grad_vec, irow, jcol, delta, options)
% Away step based on full optimization in the current face using simple prox gradient scheme.
%Input: Zk, grad_vec represent the current point
%       Omega, X_obs_vec, delta describe the instance
%Output: away_direction is the away step
%        alpha_full is the maximum step-size to the relative boundary
%        alpha_partial is a partial line-search step-size
%        away_wolfe_neg is not meaningful here
%        interior_warm_flag is whether Zk is on the interior of the nuclear norm ball (only relevant if we call a standard away step)



nuc_norm = sum(Zk.d);
U = nuc_norm*Zk.U; % standardize simplex
V = Zk.V;
r = length(Zk.d);
no_obs = length(irow);

if abs(delta - nuc_norm) < options.boundary_TOL && length(Zk.d) > 1
    % do proximal gradient descent
    interior_warm_flag = 0;
    X_obs_vec = Zk.vec - grad_vec;
    
    % current iterate
    M_cur = diag(Zk.d)/nuc_norm; % M is the r x r matrix, our current iterate, standardize the spectrahedron
    V_M_cur = eye(r); % eigendecomposition of M_cur
    D_M_cur = M_cur;
    
    % current Z
    Zvec_cur = Zk.vec;
    objval_old = Inf;
    
    % for dual stuff
    G_sym_avg = 0;
    dual_lower_bound = 0;
    dual_lower_bound_terms = 0; % terms not involving eigenvalue, avg of f(x_i) - dot(gradf(x_i), x_i)
    eig_options = struct();
    eig_options.minmax_type = 'min';

    
    for k = 1:options.prox_grad_iters
        % do convergence test
        grad_vec_cur = Zvec_cur - X_obs_vec;
        objval_new = .5*norm(grad_vec_cur, 2)^2;
        if options.prox_grad_dual_stop == 1
            prox_gap = objval_new - dual_lower_bound;
            if prox_gap < options.prox_grad_tol
                final_prox_gap = prox_gap
                total_inner_prox_iters = k
                break;
            end
        elseif (objval_old - objval_new)/objval_new < options.prox_grad_tol
            break;
        end
        objval_old = objval_new;
        
        % compute gradient
        grad_cur = sparse(irow, jcol, grad_vec_cur);
        G_sym_cur = V'*grad_cur'*U;
        G_sym_cur = .5*(G_sym_cur + G_sym_cur');
        
        % update average and dual lower bound
        G_sym_avg = ((k-1)/k)*G_sym_avg + (1/k)*G_sym_cur;
        new_lb_terms = objval_new - dot(G_sym_cur(:), M_cur(:));
        dual_lower_bound_terms = ((k-1)/k)*dual_lower_bound_terms + (1/k)*new_lb_terms;
        
        [v_g, d_g] = fast_eigs(G_sym_avg, eig_options);
        dual_lower_bound = new_lb_terms + d_g;        
        
        
        % gradient of entropy at the current point
        G_entropy = 1 + log(diag(D_M_cur));
        G_entropy = V_M_cur*diag(G_entropy)*V_M_cur';
        
        % update point
        [V_M_cur, D_shift] = eig(G_sym_cur - G_entropy);
        D_M_cur = exp(-diag(D_shift)); % L = 1, or rather deltas cancel out?
        D_M_cur = D_M_cur/sum(D_M_cur);
        D_M_cur = diag(D_M_cur);
        M_cur = V_M_cur*D_M_cur*V_M_cur';
        
        % determine Zvec_cur
        left_cur = U*M_cur;
        Zvec_cur = project_obs_UV(left_cur, V, irow, jcol, no_obs);
        
%         left_cur = left_cur(irow, :);
%         right_cur = V(jcol, :);
%         prods_cur = bsxfun(@times, left_cur, right_cur);
%         Zvec_cur = prods_cur*ones(r, 1);
    end
    
    away_direction = Zvec_cur - Zk.vec;
    direction_params = struct(); 
    direction_params.update_type = 'away_general';
    direction_params.Delta = nuc_norm*M_cur - diag(Zk.d);
    alpha_full = 1;
    alpha_partial = 1;
    away_wolfe_neg = grad_vec'*away_direction;
    
else
    % default to regular FW step (on the interior)
    
    [away_direction, direction_params, alpha_full, alpha_partial, away_wolfe_neg, interior_warm_flag] = Away_step_standard_sparse(Zk, grad_vec, irow, jcol, delta, options);
end

end