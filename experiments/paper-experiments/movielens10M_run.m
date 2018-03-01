rng(345);
warning('error', 'MATLAB:eigs:NoEigsConverged');

load('movielens_10M.mat');

[train_data, test_data] = split_matcomp_instance(Omega, irow, jcol, Xobs_vec, 0.7);

mat_comp_instance = struct();
mat_comp_instance.X_obs_vec = train_data.Xobs_vec;
mat_comp_instance.irow = train_data.irow;
mat_comp_instance.jcol = train_data.jcol;

mat_comp_instance.irow_test = test_data.irow;
mat_comp_instance.jcol_test = test_data.jcol;
mat_comp_instance.X_test_vec = test_data.Xobs_vec;


mat_comp_instance.delta = 2.5932;

options = struct();
options.verbose = 1;
options.rel_opt_TOL = -Inf;
options.abs_opt_TOL = -Inf;
options.bound_slack = 10^-6;
options.time_limit = 14400;
options.max_iter = 40000;
options.prox_grad_tol = 10^-5;

options.gamma_1 = 0;
options.gamma_2 = Inf;
options.last_toward = 0;
options.rank_peak = 0;

options.pre_start_full = 0;

options.test_error_basic = 1;

options.svd_options.large_type = 'eigs';
options.svd_options.maxiter = 5000;
options.svd_options.tol = 10^-8;
options.svd_options.vector_stopping = 0;
options.svd_options.svd_test = 0;

% options.alg_type = 'Regular';
% [final_solnFW, historyFW] = InFace_Extended_FW_sparse(mat_comp_instance, @Away_step_standard_sparse, @update_svd, options);
% % 
% % %options.alg_type = 'InFaceAlternate';
% % %[final_solnIF_fullopt, historyIF_fullopt] = InFace_Extended_FW_sparse(mat_comp_instance, @prox_grad_face, @update_svd, options);
% % 
% options.alg_type = 'InFace';
% [final_solnIF_0Inf, historyIF_0Inf] = InFace_Extended_FW_sparse(mat_comp_instance, @Away_step_standard_sparse, @update_svd, options);

options2 = options;
options3 = options;
options.alg_type = 'Regular';
options2.alg_type = 'InFace';
options3.alg_type = 'GM';
options_cell = cell(3,1);
options_cell{1} = options;
options_cell{2} = options2;
options_cell{3} = options3;

histories = cell(3,1);
final_solns = cell(3,1);

parfor k = 1:3
    [final_solns{k}, histories{k}] = InFace_Extended_FW_sparse(mat_comp_instance, @Away_step_standard_sparse, @update_svd, options_cell{k});
end

final_solnFW = final_solns{1};
final_solnIF_0Inf = final_solns{2};
final_solnGM = final_solns{3};
historyFW = histories{1};
historyIF_0Inf = histories{2};
historyGM = histories{3};

save('movielens10M_revisionruns.mat');
%drawPlots(historyFW, historyIF, historyIF);