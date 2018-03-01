function [away_direction, direction_params, alpha_full, alpha_partial, away_wolfe_neg, interior_warm_flag] = Away_step_standard_sparse(Zk, grad_vec, irow, jcol, delta, options)
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

    [v_g, d_g] = fast_eigs(G_sym, eig_options);
    
    away_u = delta*Zk.U*v_g;
    away_v = Zk.V*v_g;

    if length(Zk.d) == 1
        alpha_full = 0;
    else
        alpha_full = delta*(v_g'*diag(1./Zk.d)*v_g) - 1;
        alpha_full = 1/alpha_full;
    end
        
elseif nuc_norm <= delta - options.boundary_TOL
    % interior case
    interior_warm_flag = 1;
    
    [u_tilde, d_tilde, v_tilde] = fast_svds(grad, svd_options);
    away_u = delta*u_tilde;
    away_v = v_tilde;
    
    if length(Zk.d) == 1
        alpha_full = 0;
    else
        % to compute alpha_right
        [Uright, Dright, Vright] = svd_rank_one_update1(Zk.U, diag(Zk.d), Zk.V, -away_u, away_v);
        alpha_right = (delta + nuc_norm)/sum(diag(Dright)); % from reverse triangle inequality
        alpha_full = FUN_FWaway_alphamax_nuke2(away_u, away_v, alpha_right , delta, Zk.U, Zk.d, Zk.V, (1<0));
    end
else
    n_norm = nuc_norm
    error('Reached an infeasible iterate')
end

% compute rest of outputs
Z_hat_vec = bsxfun(@times, away_u(irow), away_v(jcol));
away_direction = Zk.vec - Z_hat_vec;
    
away_wolfe_neg = grad_vec'*away_direction;
alpha_partial = (-away_wolfe_neg)/(norm(away_direction, 2)^2);
alpha_partial = max(min(alpha_partial, alpha_full), 0); % can possibly be negative sometimes, think more about this

direction_params = struct();
direction_params.u_away = away_u;
direction_params.v_away = away_v;
direction_params.update_type = 'away_rank_one';

end