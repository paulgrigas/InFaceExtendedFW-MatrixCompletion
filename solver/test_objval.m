function val = test_objval(Zk, irow, jcol, X_test_vec)
% get the objval on the hold out set defiend by irow, jcol

prediction_vec = direction_vals_Omega(Zk, diag(Zk.d), irow, jcol);

val = .5*norm(prediction_vec - X_test_vec, 2)^2;

end