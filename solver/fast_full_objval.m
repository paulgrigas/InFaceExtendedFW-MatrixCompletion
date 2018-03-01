function val = fast_full_objval(Z1, Z2)
% returns .5*||Z1 - Z2||_F^2
% Z1 and Z2 are SVDS

val = norm(Z1.d, 2)^2 + norm(Z2.d, 2)^2;
val = .5*val;

vprod = Z1.V'*Z2.V;
uprod = Z2.U'*Z1.U;
val = val - trace(vprod*diag(Z2.d)*uprod*diag(Z1.d));

end