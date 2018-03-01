function table_instance = add_fullycorrective_table(table_instance, alg_options)
warning('error', 'MATLAB:eigs:NoEigsConverged');

options = struct();
options.verbose = 1;
options.rel_opt_TOL = 10^-2.5;
% options.rel_opt_TOL = -Inf; 
options.abs_opt_TOL = -Inf;
options.bound_slack = 10^-6;
options.time_limit = 400; % 800 for big table examples, 400 for small 
options.max_iter = 40000;
options.prox_grad_tol = 10^-6; % or 10^-5 ? 

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


options.alg_type = 'InFaceAlternate';
options.record_svd = 0;
options.record_numatoms = 1;
options.prox_grad_doubling = 1;
options.prox_grad_iters = 50;
[final_soln_fullopt_atom, history_fullopt_atom] = InFace_Extended_FW_sparse(mat_comp_instance, @prox_grad_simplex, @update_overcomplete, options);
table_instance.history_fullopt_atom = history_fullopt_atom;
table_instance.final_soln_fullopt_atom = final_soln_fullopt_atom;

%best_lwbnd_fullopt_atom = max(history_fullopt_atom.lowerbnds(1:history_fullopt_atom.num_iters));

%table_instance.best_lwbnd = max(table_instance.best_lwbnd, best_lwbnd_fullopt_atom); DONT do this, may mess up previous things

end