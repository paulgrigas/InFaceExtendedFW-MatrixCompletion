function table_instance = run_algs_table(table_instance, alg_options)
warning('error', 'MATLAB:eigs:NoEigsConverged');

options = struct();
options.verbose = 1;
%options.rel_opt_TOL = 10^-2.5;
options.rel_opt_TOL = -Inf; 
options.abs_opt_TOL = -Inf;
options.bound_slack = 10^-6;
options.time_limit = 800;
options.max_iter = 40000;
options.prox_grad_tol = 10^-5;

options.svd_options.large_type = 'eigs';
options.svd_options.maxiter = 5000;
options.svd_options.tol = 10^-8;
options.svd_options.vector_stopping = 0;
options.svd_options.svd_test = 0;

options.last_toward = 0;
options.rank_peak = 0;
options.gamma_1 = 1;
options.gamma_2 = 1;

options.pre_start_full = 0; % turn pre-start off for all methods

if nargin == 2
    alg_options_fn = fieldnames(alg_options);
    for i = 1:length(alg_options_fn)
        options.(alg_options_fn{i}) = alg_options.(alg_options_fn{i});
    end
end

mat_comp_instance = table_instance.mat_comp_instance;

%%%% Regular FW %%%%

options.alg_type = 'Regular';
[final_solnFW, historyFW] = InFace_Extended_FW_sparse(mat_comp_instance, @Away_step_standard_sparse, @update_svd, options);
table_instance.historyFW = historyFW;
table_instance.final_solnFW = final_solnFW;

%%%% Our variants %%%% 
options.alg_type = 'InFace';
options.gamma_1 = 1;
options.gamma_2 = 1; % Inf
[final_solnIF_11, historyIF_11] = InFace_Extended_FW_sparse(mat_comp_instance, @Away_step_standard_sparse, @update_svd, options);
table_instance.historyIF_11 = historyIF_11;
table_instance.final_solnIF_11 = final_solnIF_11;

options.alg_type = 'InFace';
options.gamma_1 = 0;
options.gamma_2 = 1;
[final_solnIF_01, historyIF_01] = InFace_Extended_FW_sparse(mat_comp_instance, @Away_step_standard_sparse, @update_svd, options);
table_instance.historyIF_01 = historyIF_01;
table_instance.final_solnIF_01 = final_solnIF_01;

options.alg_type = 'InFace';
options.gamma_1 = 0;
options.gamma_2 = Inf;
[final_solnIF_0Inf, historyIF_0Inf] = InFace_Extended_FW_sparse(mat_comp_instance, @Away_step_standard_sparse, @update_svd, options);
table_instance.historyIF_0Inf = historyIF_0Inf;
table_instance.final_solnIF_0Inf = final_solnIF_0Inf;

options.alg_type = 'InFace';
options.gamma_1 = 1;
options.gamma_2 = 1;
options.rank_peak = 1;
[final_solnIF_peak, historyIF_peak] = InFace_Extended_FW_sparse(mat_comp_instance, @Away_step_standard_sparse, @update_svd, options);
options.rank_peak = 0;
table_instance.historyIF_peak = historyIF_peak;
table_instance.final_solnIF_peak = final_solnIF_peak;

options.alg_type = 'InFaceAlternate';
[final_solnIF_fullopt, historyIF_fullopt] = InFace_Extended_FW_sparse(mat_comp_instance, @prox_grad_face, @update_svd, options);
table_instance.historyIF_fullopt = historyIF_fullopt;
table_instance.final_solnIF_fullopt = final_solnIF_fullopt;

%%%% Comparisons %%%%%
options.alg_type = 'GM';
[final_solnGM, historyGM] = InFace_Extended_FW_sparse(mat_comp_instance, @Away_step_standard_sparse, @update_svd, options);
table_instance.historyGM = historyGM;
table_instance.final_solnGM = final_solnGM;

options.alg_type = 'GM';
options.record_svd = 1;
options.record_numatoms = 1;
[final_solnGM_atom, historyGM_atom] = InFace_Extended_FW_sparse(mat_comp_instance, @Away_step_simplex_sparse, @update_overcomplete, options);
table_instance.historyGM_atom = historyGM_atom;
table_instance.final_solnGM_atom = final_solnGM_atom;

options.alg_type = 'InFaceAlternate';
options.record_svd = 0;
options.record_numatoms = 1;
options.prox_grad_tol = 10^-6;
options.prox_grad_doubling = 1;
[final_soln_fullopt_atom, history_fullopt_atom] = InFace_Extended_FW_sparse(mat_comp_instance, @prox_grad_simplex, @update_overcomplete, options);
table_instance.history_fullopt_atom = history_fullopt_atom;
table_instance.final_soln_fullopt_atom = final_soln_fullopt_atom;

best_lwbndFW = max(historyFW.lowerbnds(1:historyFW.num_iters));
best_lwbndIF_11 = max(historyIF_11.lowerbnds(1:historyIF_11.num_iters));
best_lwbndIF_01 = max(historyIF_01.lowerbnds(1:historyIF_01.num_iters));
best_lwbndIF_0Inf = max(historyIF_0Inf.lowerbnds(1:historyIF_0Inf.num_iters));
best_lwbndIF_peak = max(historyIF_peak.lowerbnds(1:historyIF_peak.num_iters));
best_lwbndIF_fullopt = max(historyIF_fullopt.lowerbnds(1:historyIF_fullopt.num_iters));
best_lwbndGM = max(historyGM.lowerbnds(1:historyGM.num_iters));
best_lwbndGM_atom = max(historyGM_atom.lowerbnds(1:historyGM_atom.num_iters));
best_lwbnd_fullopt_atom = max(history_fullopt_atom.lowerbnds(1:history_fullopt_atom.num_iters));

best_lwbnd = max([best_lwbndFW, best_lwbndIF_11, best_lwbndIF_01, best_lwbndIF_0Inf, best_lwbndIF_peak, best_lwbndIF_fullopt, best_lwbndGM, best_lwbndGM_atom, best_lwbnd_fullopt_atom]);
table_instance.best_lwbnd = best_lwbnd;

end