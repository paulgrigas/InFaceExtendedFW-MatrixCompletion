function [reg_direction_vec, direction_params, new_lowerbnd, new_lowerbnd_sv, wolfe_gap_neg] = Regular_FW_direction_sparse(Zk, grad_vec, objval, lowerbnd, lowerbnd_sv, mat_comp_instance, options)
% Input: Zk, grad_vec, and objval represent the current iterate
% lowerbnd is the current lower bound B_k
% irow, jcol represents the observed entries
% X_obs_vec is the vector of observations
% delta is regularization parameter
%
% Output: regular_direction
% new_lowerbnd is B_{k+1}
% wolfe_gap_neg is the negative of the wolfe gap, useful for Guelat-Marcot

bound_slack = options.bound_slack;
svd_options = options.svd_options;

irow = mat_comp_instance.irow;
jcol = mat_comp_instance.jcol;
delta = mat_comp_instance.delta;

% set up and find Zk_tilde
grad = sparse(irow, jcol, grad_vec);
[u_tilde, d_tilde, v_tilde] = fast_svds(grad, svd_options);
u_tilde = -delta*u_tilde;
Zk_tilde_vec = bsxfun(@times, u_tilde(irow), v_tilde(jcol));
reg_direction_vec = Zk_tilde_vec - Zk.vec;

% update lower bound
wolfe_gap_neg = grad_vec'*reg_direction_vec;
wolfe_lowerbnd = objval + wolfe_gap_neg - bound_slack;
if wolfe_lowerbnd > lowerbnd
    new_lowerbnd = wolfe_lowerbnd;
    new_lowerbnd_sv = d_tilde;
else
    new_lowerbnd = lowerbnd;
    new_lowerbnd_sv = lowerbnd_sv;
end

direction_params = struct();
direction_params.u_tilde = u_tilde;
direction_params.v_tilde = v_tilde;
direction_params.update_type = 'regular';

if options.hold_out_set_smart == 1
    Zk_tilde_test_vec = bsxfun(@times, u_tilde(mat_comp_instance.irow_test), v_tilde(mat_comp_instance.jcol_test));
    direction_params.test_direction = Zk_tilde_test_vec - Zk.test_vec;
end

end