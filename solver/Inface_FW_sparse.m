function [away_direction, direction_params, alpha_full, alpha_partial, away_wolfe_neg, interior_warm_flag] = Inface_FW_sparse(Zk, grad_vec, irow, jcol, delta, options)
% Away step based on a normal Frank-Wolfe step on the current face
%Input: Zk, grad_vec represent the current point
%       Omega, X_obs_vec, delta describe the instance
%Output: away_direction is the away step
%        alpha_full is the maximum step-size to the relative boundary
%        alpha_partial is a partial line-search step-size
%        away_wolfe_neg is a quantity needed for GM decision rule, see paper
%        interior_warm_flag is whether Zk is on the interior of the nuclear norm ball

% pre process
svd_options = options.svd_options;
eig_options = options.eig_options;

grad = sparse(irow, jcol, grad_vec);
nuc_norm = sum(Zk.d);

if abs(delta - nuc_norm) < options.boundary_TOL
    % boundary case
    interior_warm_flag = 0;
    
    G_sym = Zk.V'*grad'*Zk.U;
    G_sym = .5*(G_sym + G_sym');
    
    eig_options.minmax_type = 'min';
    [v_g, d_g] = fast_eigs(G_sym, eig_options);
    
    away_u = delta*Zk.U*v_g;
    away_v = Zk.V*v_g;

    if length(Zk.d) == 1
        alpha_full = 0;
    else
        alpha_full = 1;
    end
        
elseif nuc_norm <= delta - options.boundary_TOL
    % interior case
    interior_warm_flag = 1;
    
    [u_tilde, d_tilde, v_tilde] = fast_svds(grad, svd_options);
    away_u = -delta*u_tilde;
    away_v = v_tilde;
    
    alpha_full = 1;
else
    n_norm = nuc_norm
    error('Reached an infeasible iterate')
end

% compute rest of outputs
Z_hat_vec = bsxfun(@times, away_u(irow), away_v(jcol));
away_direction = Z_hat_vec - Zk.vec;
    
away_wolfe_neg = grad_vec'*away_direction;
alpha_partial = (-away_wolfe_neg)/(norm(away_direction, 2)^2);
alpha_partial = max(min(alpha_partial, alpha_full), 0); % can possibly be negative sometimes, think more about this

direction_params = struct();
direction_params.u_away = away_u;
direction_params.v_away = away_v;
direction_params.u_tilde = away_u;
direction_params.v_tilde = away_v;
direction_params.update_type = 'regular';

end