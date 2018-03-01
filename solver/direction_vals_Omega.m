function direction_vec = direction_vals_Omega(Zk, Delta, irow, jcol)
% Consider the direction Zk.U*Delta*Zk.V' where Delta is r x r symmetric
% Compute the values of this direction on the Omega entries defined by irow, jcol in an efficient way

no_obs = length(irow);
left = Zk.U*Delta;
right = Zk.V;

direction_vec = project_obs_UV(left, right, irow, jcol, no_obs);



%%%% DEPRECATED %%%%
% r = length(Zk.d);
% 
% left = Zk.U*Delta;
% right = Zk.V';
% 
% left = left(irow, :);
% right = right(:, jcol);
% 
% prods = bsxfun(@times, left, right');
% 
% direction_vec = prods*ones(r, 1);

end