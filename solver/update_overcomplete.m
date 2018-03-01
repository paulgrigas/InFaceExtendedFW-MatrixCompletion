function new_point = update_overcomplete(old_point, direction_params, alpha, tol)
%   updates the over complete basis of FW atoms of new_point = old_point + alpha*direction
%   look at direction_params.update_type:
%       if 'regular', direction = (u_tilde*v_tilde' - old_point)
%       if 'away_rank_one', direction = (old_point - u_away*v_away')
%       if 'away_general',  adjust the weights
%   note that alpha may be positive or negative
%   only works with atomic away steps

Uold = old_point.U;
dold = old_point.d;
Vold = old_point.V;

if strcmp(direction_params.update_type, 'regular')
    % normalize
    u = direction_params.u_tilde;
    v = direction_params.v_tilde;
    norm_u = norm(u, 2);
    norm_v = norm(v, 2);
    u = u/norm_u;
    v = v/norm_v;
    delta = norm_u*norm_v;
    
    if isempty(dold) && alpha < 1
        Uold = zeros(length(u), 1);
        Vold = zeros(length(v), 1);
        dold = delta;
    end
    
    dnew = (1 - alpha)*dold;
    dnew = [dnew; alpha*delta];
    Unew = [Uold, u];
    Vnew = [Vold, v];
elseif strcmp(direction_params.update_type, 'simplex_away_rank_one')
    id_away = direction_params.id_away;
    delta = sum(dold);
    
    dnew = (1 + alpha)*dold;
    dnew(id_away) = dnew(id_away) - alpha*delta;
    
    Unew = Uold;
    Vnew = Vold;
elseif strcmp(direction_params.update_type, 'weights_general')  
    dnew = direction_params.new_weights;
    Unew = Uold;
    Vnew = Vold;
else
    error('Enter a valid update type');
end

Dnew = diag(dnew);
[Unew, Dnew, Vnew] = thinSVD(Unew, Dnew, Vnew, tol);

new_point = struct();
new_point.U = Unew;
new_point.V = Vnew;
new_point.d = diag(Dnew);
new_point.vec = old_point.vec;

end
