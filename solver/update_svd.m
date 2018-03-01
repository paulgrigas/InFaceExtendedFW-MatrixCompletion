function new_point = update_svd(old_point, direction_params, alpha, tol)
%   updates the low-rank SVD of new_point = old_point + alpha*direction
%   look at direction_params.update_type:
%       if 'regular', direction = (u_tilde*v_tilde' - old_point)
%       if 'away_rank_one', direction = (old_point - u_away*v_away')
%       if 'away_general', direction = U*Delta*V' (Delta is r x r symmetric)
%   note that alpha may be positive or negative

Uold = old_point.U;
dold = old_point.d;
Vold = old_point.V;

if strcmp(direction_params.update_type, 'regular') || strcmp(direction_params.update_type, 'away_rank_one') || strcmp(direction_params.update_type, 'simplex_away_rank_one')
    if strcmp(direction_params.update_type, 'regular')
        u = direction_params.u_tilde;
        v = direction_params.v_tilde;
    end
    if strcmp(direction_params.update_type, 'away_rank_one') || strcmp(direction_params.update_type, 'simplex_away_rank_one')
        u = direction_params.u_away;
        v = direction_params.v_away;
        alpha = -alpha;
    end

    dold = (1 - alpha)*dold;

    u_add = alpha*u;
    v_add = v;

    if isempty(Uold) && isempty(Vold) && isempty(dold)
        u_norm = norm(u, 2);
        v_norm = norm(v, 2);
        Unew = u/u_norm;
        Vnew = v/v_norm;
        Dnew = alpha*u_norm*v_norm;
    else
        [Unew, Dnew, Vnew] = svd_rank_one_update1(Uold, diag(dold), Vold, u_add, v_add);
    end
elseif strcmp(direction_params.update_type, 'away_general')
    Delta = direction_params.Delta;
    
    [R, Dnew] = eig(diag(dold) + alpha*Delta);
    Unew = Uold*R;
    Vnew = Vold*R;
elseif strcmp(direction_params.update_type, 'weights_general') && ~isfield(direction_params, 'overcomplete_flag')
    % using weights general and this is a normal update as part of the algorithm
    Unew = Uold;
    Vnew = Vold;
    Dnew = diag(direction_params.new_weights);
elseif strcmp(direction_params.update_type, 'weights_general') && isfield(direction_params, 'overcomplete_flag')
    % using weights general and this is a copy update
    % Uold, Vold now represent the overcomplete basis
    new_weights = direction_params.new_weights;
    R = length(new_weights);
    if R ~= length(dold)
        error('Mismatched dimensions with old vs. new weights');
    end
    
    % iteratively apply the rank one updates
    Unew = Uold(:, 1);
    unew_norm = norm(Unew, 2);
    Vnew = Vold(:, 1);
    vnew_norm = norm(Vnew, 2);
    if unew_norm < tol || vnew_norm < tol
        start_ind = 2;
        Unew = Uold(:, 2);
        Vnew = Vold(:, 2);
        unew_norm = norm(Unew, 2);
        vnew_norm = norm(Vnew, 2);
    else
        start_ind = 1;
    end
    Unew = Unew/unew_norm;
    Vnew = Vnew/vnew_norm;
    Dnew = new_weights(start_ind)*unew_norm*vnew_norm;
    
    for i = (start_ind+1):R
        u_add = new_weights(i)*Uold(:, i);
        v_add = Vold(:, i);
        [Unew, Dnew, Vnew] = svd_rank_one_update1(Unew, Dnew, Vnew, u_add, v_add);
    end
    
else
    error('Enter a valid update type');
end

[Unew, Dnew, Vnew] = thinSVD(Unew, Dnew, Vnew, tol);

new_point = struct();
new_point.U = Unew;
new_point.V = Vnew;
new_point.d = diag(Dnew);
new_point.vec = old_point.vec;
end