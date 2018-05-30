function path_history = InFace_Extended_FW_sparse_path(mat_comp_instance, alt_fun, update_representation, options)
% See InFace_Extended_FW_sparse for documentation of inputs
%
% mat_comp_instance.delta no longer relevant
% now includes:
%   'delta_min'     = smallest value of delta we are interested in
%   'delta_max'     = largest value of detla we are interested in
%   'delta_list'    = list of delta values, if path type is 'list'
%   'dual_norm_bound' 
% 
% options includes:
%   'path_type'    = type of delta path, can be either 'constant_accuracy' or 'list'
%   'hold_out_set'  = record test value on hold out set
%   'full_objval'   = record full frobenius norm difference compared to true model
%   'hold_out_set_smart'
% Be sure to set rel_OPT_TOL equal to 0 if doing constant_accuracy
% mat_comp_instance.irow_test, mat_comp_instance.jcol_test, mat_comp_instance.X_test_vec need to be defined for hold out set
% history


%%%% Options %%%%
options_use = struct();
options_use.path_type = 'constant_accuracy';
options_use.hold_out_set = 0;
options_use.full_objval = 0;
options_use.hold_out_set_smart = 0;

% overwrite defaults for things that are set
options_fn = fieldnames(options);
for i = 1:length(options_fn)
    options_use.(options_fn{i}) = options.(options_fn{i});
end

% rename back to options
options = options_use;


%%%% Begin Algorithm %%%%%

% set subinterval length, solve the path to an accuracy of 2*options.abs_opt_TOL
% subinterval_length = options.abs_opt_TOL/mat_comp_instance.delta_max; dont' need this by frobenius norm agrument
subinterval_length = options.abs_opt_TOL/mat_comp_instance.dual_norm_bound;

% set initial delta
if strcmp(options.path_type, 'constant_accuracy')
    current_delta = max(mat_comp_instance.delta_min, subinterval_length) % in case delta_min close to 0
elseif strcmp(options.path_type, 'list')
    current_delta = mat_comp_instance.delta_list(1)
    mat_comp_instance.delta_max = mat_comp_instance.delta_list(length(mat_comp_instance.delta_list));
else
    error('Enter a valid delta type');
end

% initial solve
mat_comp_instance.delta = current_delta;
[Zk, history, dynamic_info] = InFace_Extended_FW_sparse(mat_comp_instance, alt_fun, update_representation, options);

% set history
path_history.bound_gaps_nooffset = history.bound_gaps_nooffset(1:history.num_iters);
path_history.cputimes = history.cputimes(1:history.num_iters);
path_history.ranks = history.ranks(1:history.num_iters);
path_history.deltas = current_delta*ones(history.num_iters, 1);

path_history.deltas_norepeats = current_delta;
path_history.minranks = history.ranks(history.num_iters);
path_history.objvals = history.objvals(history.num_iters);

% check if test set

if options.hold_out_set == 1
    path_history.test_vals = test_objval(Zk, mat_comp_instance.irow_test, mat_comp_instance.jcol_test, mat_comp_instance.X_test_vec);
end
if options.full_objval == 1
    path_history.full_objvals = fast_full_objval(Zk, mat_comp_instance.Z_star);
end
if options.hold_out_set_smart == 1
    path_history.test_vals_smart = .5*norm(Zk.test_vec - mat_comp_instance.X_test_vec, 2)^2;
end

% update delta
if strcmp(options.path_type, 'constant_accuracy')
    current_delta = current_delta + subinterval_length
elseif strcmp(options.path_type, 'list')
    previous_delta = current_delta;
    current_delta = mat_comp_instance.delta_list(2)
    loop_count = 3;
else
    error('Enter a valid delta type');
end


% begin path algorithm
while current_delta <= mat_comp_instance.delta_max
    mat_comp_instance.delta = current_delta;
    
    start_params = struct();
    start_params.Z0 = Zk;
    start_params.lowerbnd_sv = dynamic_info.lowerbnd_sv;
    start_params.warm_start = dynamic_info.warm_start;
    % update lower bound
    if strcmp(options.path_type, 'constant_accuracy')
        start_params.lowerbnd = max(dynamic_info.lowerbnd - subinterval_length*dynamic_info.lowerbnd_sv, 0);
    elseif strcmp(options.path_type, 'list')
        start_params.lowerbnd = max(dynamic_info.lowerbnd - (current_delta - previous_delta)*dynamic_info.lowerbnd_sv, 0);
    else
        error('Enter a valid delta type');
    end
    
    % solve
    [Zk, history, dynamic_info] = InFace_Extended_FW_sparse(mat_comp_instance, alt_fun, update_representation, options, start_params);
    
    % update history
    path_history.bound_gaps_nooffset = [path_history.bound_gaps_nooffset; history.bound_gaps_nooffset(2:history.num_iters)];
    new_cputimes = history.cputimes(2:history.num_iters) + path_history.cputimes(length(path_history.cputimes))*ones(history.num_iters - 1, 1);
    path_history.cputimes = [path_history.cputimes; new_cputimes];
    path_history.ranks = [path_history.ranks; history.ranks(2:history.num_iters)];
    path_history.deltas = [path_history.deltas; current_delta*ones(history.num_iters - 1, 1)];
    
    path_history.deltas_norepeats = [path_history.deltas_norepeats; current_delta];
    path_history.minranks = [path_history.minranks; min(history.ranks(2:history.num_iters))];
    
    path_history.objvals = [path_history.objvals; history.objvals(history.num_iters)];
    
    if options.hold_out_set == 1
        path_history.test_vals = [path_history.test_vals; test_objval(Zk, mat_comp_instance.irow_test, mat_comp_instance.jcol_test, mat_comp_instance.X_test_vec)];
    end
    if options.full_objval == 1
        path_history.full_objvals = [path_history.full_objvals; fast_full_objval(Zk, mat_comp_instance.Z_star)];
    end
    if options.hold_out_set_smart == 1
        path_history.test_vals_smart = [path_history.test_vals_smart; .5*norm(Zk.test_vec - mat_comp_instance.X_test_vec, 2)^2];
    end

    
    % update delta
    if strcmp(options.path_type, 'constant_accuracy')
        current_delta = current_delta + subinterval_length
    elseif strcmp(options.path_type, 'list')
        if loop_count <= length(mat_comp_instance.delta_list)
            previous_delta = current_delta;
            current_delta = mat_comp_instance.delta_list(loop_count)
            loop_count = loop_count + 1;
        else
        	current_delta = mat_comp_instance.delta_max + 1;
        end
    else
        error('Enter a valid delta type');
    end
    
    % check if we reached least squares
    cur_objval = history.objvals(history.num_iters)
    if history.objvals(history.num_iters) < options.abs_opt_TOL
        break;
    end
end

end