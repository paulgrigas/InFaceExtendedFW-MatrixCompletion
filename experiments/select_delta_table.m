function table_instance = select_delta_table(mat_comp_instance)
warning('error', 'MATLAB:eigs:NoEigsConverged');

table_instance = struct();

%%%% Begin path algorithm to select delta %%%%%
options = struct();
options.verbose = 0;
options.abs_opt_TOL = 10^-2;
options.rel_opt_TOL = -Inf;
options.full_objval = 1;

historyFWpath = InFace_Extended_FW_sparse_path(mat_comp_instance, @Away_step_standard_sparse, @update_svd, options);

% train_baseline = .5*norm(Xobs_vec, 2)^2;
% full_baseline = .5*norm(Z_star.d, 2)^2;
% figure
% plot(historyFWpath.deltas_norepeats, historyFWpath.objvals./train_baseline, 'r', historyFWpath.deltas_norepeats, historyFWpath.full_objvals./full_baseline, 'b');
% title('Training/Testing Error vs. Delta')


%%%%% Choose delta and begin algorithm comparisons %%%%%%%%
delta_found = find_best_delta(historyFWpath, 1, 10^-3, 1);
table_instance.delta_found = delta_found;

mat_comp_instance.delta = delta_found;
table_instance.mat_comp_instance = mat_comp_instance;

end