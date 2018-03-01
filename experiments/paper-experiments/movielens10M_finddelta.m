%[no_obs, Omega, irow, jcol, Xobs_vec] = read_movielens_10M();
load('movielens_10M.mat');

m_size = max(irow);
n_size = max(jcol);

[train_data, test_data] = split_matcomp_instance(Omega, irow, jcol, Xobs_vec, 0.8);

% sanity
num_train_rows = length(unique(train_data.irow))
num_train_cols = length(unique(train_data.jcol))


mat_comp_instance = struct();
mat_comp_instance.X_obs_vec = train_data.Xobs_vec;
mat_comp_instance.irow = train_data.irow;
mat_comp_instance.jcol = train_data.jcol;

mat_comp_instance.delta_min = 0;
mat_comp_instance.dual_norm_bound = norm(train_data.Xobs_vec, 2);
mat_comp_instance.delta_max = sqrt(min(m_size, n_size))*mat_comp_instance.dual_norm_bound;

mat_comp_instance.irow_test = test_data.irow;
mat_comp_instance.jcol_test = test_data.jcol;
mat_comp_instance.X_test_vec = test_data.Xobs_vec;

options = struct();
options.verbose = 0;
options.abs_opt_TOL = 10^-2;
options.rel_opt_TOL = -Inf;
options.hold_out_set_smart = 1;
options.regular_fast = 1;

tic;
historyFWpath = InFace_Extended_FW_sparse_path(mat_comp_instance, @Away_step_standard_sparse, @update_svd, options);
total_path_time = toc;

train_baseline = .5*norm(train_data.Xobs_vec, 2)^2;
test_baseline = .5*norm(test_data.Xobs_vec, 2)^2;

figure
plot(historyFWpath.deltas_norepeats, historyFWpath.objvals./train_baseline, 'r', historyFWpath.deltas_norepeats, historyFWpath.test_vals_smart./test_baseline, 'b');
title('Training/Testing Error vs. Delta')

save('movielens10M_finddelta.mat');