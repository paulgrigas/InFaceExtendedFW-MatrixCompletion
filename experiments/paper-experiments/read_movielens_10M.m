function [no_obs, Omega, irow, jcol, Xobs_vec] = read_movielens_10M()

    M = dlmread('ratings.dat');

    irow = M(:, 1); % users
    jcol = M(:, 3); % movies
    
    % fix irow, jocl
    [unique_rows, irow_ind, unique_rows_ind] = unique(irow); 
    [unique_cols, jcol_ind, unique_cols_ind] = unique(jcol); 
    
    nrow = length(unique_rows);
    ncol = length(unique_cols);
    
    irow = (1:nrow)';
    irow = irow(unique_rows_ind);
    jcol = (1:ncol)';
    jcol = jcol(unique_cols_ind);

    
    Omega = sub2ind([nrow,ncol],irow,jcol);

    Xobs_vec = M(:, 5);
    no_obs = length(Xobs_vec);

    % center the data
    centerMatRows = [1:no_obs, 1:no_obs]';
    centerMatCols = [irow; nrow + jcol];
    centerMat = sparse(centerMatRows, centerMatCols, ones(2*no_obs, 1));
    
    alphabeta = lsqr(centerMat, Xobs_vec, 10^-6, 1000);
    alpha = alphabeta(1:nrow);
    beta = alphabeta(nrow+1:nrow+ncol);

    Xobs_vec = Xobs_vec - alpha(irow) - beta(jcol);
    
    Xobs_vec = Xobs_vec/norm(Xobs_vec, 2);

end