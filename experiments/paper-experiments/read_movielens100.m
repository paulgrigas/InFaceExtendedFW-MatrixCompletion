nrow = 943; % users
ncol = 1682; % items
no_obs = 100000;

tdfread('movielens100.data');

irow = user_id;
jcol = item_id;

Omega = sub2ind([nrow,ncol],irow,jcol);

Xobs_vec = rating;

centerMat = sparse(no_obs, nrow + ncol);

for k = 1:no_obs
    centerMat(k, irow(k)) = 1;
    centerMat(k, nrow + jcol(k)) = 1;
end

alphabeta = lsqr(centerMat, Xobs_vec, 10^-6, 1000);
alpha = alphabeta(1:nrow);
beta = alphabeta(nrow+1:nrow+ncol);

Xobs_vec = Xobs_vec - alpha(irow) - beta(jcol);

POmega = sparse(irow,jcol,1);
POmegaX = sparse(irow, jcol, Xobs_vec, nrow, ncol);


% Is this smart?
POmegaX_fronorm = norm(POmegaX, 'fro');

POmegaX = POmegaX/POmegaX_fronorm;

% nucnorm(POmegaX) = 18.7576 without centering

% nucnorm(POmegaX) = 22.2599 with centering


Xobs_vec = full(POmegaX(Omega));
