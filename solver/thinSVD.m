function [U_new, D_new, V_new] = thinSVD(U, D, V, tol)
% thin the SVD U*D*V'
d = diag(D);
ids = d > tol;
U_new = U(:, ids);
V_new = V(:, ids);
D_new = diag(d(ids));
end