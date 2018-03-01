function [away_direction, direction_params, alpha_full, alpha_partial, away_wolfe_neg, interior_warm_flag] = Away_step_simplex_sparse(Zk, grad_vec, irow, jcol, delta, options)
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

% determine away direction
grad = sparse(irow, jcol, grad_vec);
id_max = 0;
val_max = -Inf;
for i = 1:r
    u_cur = Zk.U(:, i);
    v_cur = Zk.V(:, i);
    %rone_cur = bsxfun(@times, u_cur(irow), v_cur(jcol));
    %val_cur = grad_vec'*rone_cur;
    val_cur = u_cur'*(grad*v_cur);
    if val_cur > val_max
        val_max = val_cur;
        id_max = i;
    end
end
away_u = delta*Zk.U(:, id_max);
away_v = Zk.V(:, id_max);

% determine alpha_full
alpha_atom = Zk.d(id_max)/sum(Zk.d);
alpha_full = alpha_atom/(1 - alpha_atom);

% determine alpha_partial
Z_hat_vec = bsxfun(@times, away_u(irow), away_v(jcol));
away_direction = Zk.vec - Z_hat_vec;
    
away_wolfe_neg = grad_vec'*away_direction;
alpha_partial = (-away_wolfe_neg)/(norm(away_direction, 2)^2);
alpha_partial = max(min(alpha_partial, alpha_full), 0);

direction_params = struct();
direction_params.id_away = id_max;
direction_params.u_away = away_u;
direction_params.v_away = away_v;
direction_params.update_type = 'simplex_away_rank_one';

end