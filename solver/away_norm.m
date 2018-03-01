function val = away_norm(old_point, direction_params, alpha)
% returns ||alpha*d_k||_\ast = alpha*||d_k||_\ast
% if 'away_rank_one', direction = (old_point - u_away*v_away')
% if 'away_general', direction = U*Delta*V' (Delta is r x r symmetric)

Uold = old_point.U;
dold = old_point.d;
Vold = old_point.V;

if strcmp(direction_params.update_type, 'away_rank_one')
    u = direction_params.u_away;
    v = direction_params.v_away;
    
    if isempty(Uold) && isempty(Vold) && isempty(dold)
        u_norm = norm(u, 2);
        v_norm = norm(v, 2);
        val = alpha*u_norm*v_norm;
    else
        u_add = -u;
        v_add = v;
        [Unew, Dnew, Vnew] = svd_rank_one_update1(Uold, diag(dold), Vold, u_add, v_add);
        val = sum(diag(Dnew));
        val = alpha*val;
    end
    
elseif strcmp(direction_params.update_type, 'away_general')
     Delta = direction_params.Delta;
%     
%     [R, Dnew] = eig(Delta);
%     val = sum(diag(Dnew));
%     val = alpha*val;
    disp('inefficient way to compute nuclear norm of general in-face directions');
    direction_mat = Uold*Delta*Vold';
    val = sum(svd(direction_mat, 'econ'));
    val = alpha*val;
else
    error('enter a valid direction type');
end

end