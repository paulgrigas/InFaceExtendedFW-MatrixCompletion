rank_TOL = 10^-6;
load('ex8_big_updated_FC_july2.mat');
final_FC = table_instance.final_soln_fullopt_atom;
[U_FC, d_FC, V_FC] = svd(final_FC.U*diag(final_FC.d)*final_FC.V', 'econ');
table_instance.history_fullopt_atom.final_true_rank = sum(diag(d_FC) > rank_TOL);
save('ex8_big_updated_FC_july2.mat_v2.mat');

maxatoms = max(table_instance.history_fullopt_atom.numatoms)
final_true_rank = table_instance.history_fullopt_atom.final_true_rank