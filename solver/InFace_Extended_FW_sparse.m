function [Zk, history] = InFace_Extended_FW_sparse(mat_comp_instance, alt_fun, update_representation, options, start_params)
% Implements In Face Extended Frank-Wolfe (Algorithm 3)
% Variables are stored and manipulated in a sparse/low-rank manner, appropriate for large-scale problems
%
% INPUTS
% mat_comp_instance is a structure describing the matrix completion problem instance, with the following fields:
%   'X_obs_vec' = vector of observations
%   'irow'      = vector of row indicies
%   'jcol'      = vector of column indicies
%   'delta'     = reg parameter
%   'X_test_vec' = vector of observations on the test set, if we keep this
%
%   All iterates, directions, etc. are represtend as a structure with the following fields:
%   'vec'   = vector of values on the observed indicies Omega       
%   'U'     = these three store the low-rank representation such that X = \sum_{i = 1}^r d_i*u_i*v_i'
%   'd'       usually this is just the SVD of the iterate, but sometimes not (atomic away steps)
%   'V'
%
% alt_fun is a handle to a function for computing the alternative direction
%   [away_direction, away_u, away_v, alpha_full, alpha_partial, away_wolfe_neg] = alt_fun(Zk, grad_vec, irow, jcol, delta, options)
%       Input: Zk, grad_vec represent the current point
%       Output: away_direction is the direction
%               alpha_full is the maximum step-size to the relative boundary
%               alpha_partial is a partial (usually line search) step-size
%               away_wolfe_neg is a quantity needed for GM decision rule, see paper
%
% update_representation is a handle to a function for updating the low-rank representation after moving in a direction
%   new_point = update_representation(old_point, u, v, alpha, tol)
%   updates the low-rank representation of new_point = old_point + alpha*(u*v' - old_point)
%   note that alpha may be positive or negative
%   does not update the sparse vector
%
% start_params is initialization info
%   'Z0'            = initial iterate
%   'lowerbnd'      = initial lower bound
%   'lowerbnd_sv'   = largest singular corresponding to the lowerbnd
%   'warm_start'    = warm start right singular vector
%
% options is an structure of optional parameters with the following fields and default values:
%   'alg_type'      = type of algorithm
%       possible values:    'Regular', 'GM', 'InFace', 'InFaceAlternate'
%       default = 'Regular'
%   'verbose'       = display text output at each iterations                    
%       default = 0
%   'max_iter'      = maximum number of iterations                              
%       default = 1000
%   'time_limit'    = maximum number of seconds to run                          
%       default = 100
%   'rel_opt_TOL'       = terminate when we reach this relative optimality gap      
%       default = 10^-3
%   'abs_opt_TOL'       = terminate when we reach this absolute optimality gap
%       default = 0
%   'rank_TOL'      = tolerance for rank cutoffs                                
%       default = 10^-6
%   'boundary_TOL'  = tolerance for deciding if we are on the boundary          
%       default = 10^-3
%   'alpha_TOL'     = tolerance for when alpha is small
%   'bound_slack'   = amount that we subtract from FW lower bounds for numerical stability reasons
%       default = 10^-6
%   'gamma_1'       = algorithm parameter (see paper) 
%       default = 1
%   'gamma_2'       = algorithm parameter (see paper)
%       defulat = 1
%   'last_toward'   = test relative to last toward step as opposed to constant gamma
%       default = 0
%   'rank_peak'     = use the rank peak heurisitic
%       default = 0
%   'rank_stall_thresh'     = how many iterations for rank to remain constant before turning on away steps
%       default = 5
%   'svd_options'   = struct for options about svd, see fast_svds
%   'eig_options'   = struct for options about eig, see fast_eigs
%   'svdtol_opttol_related' = if equal to 1, then set svd and eig tols based on opt TOL
%       sets bound slack appropriately
%   'prox_grad_iters'   = maximum number of iterations for (accelerated) proximal gradient descent on the face
%   'prox_grad_tol'     = tolerance for prox gradient algorithm
%   'regular_fast'      = dont update the low-rank representation for regular FW
%   'hold_out_set_smart'      = keep a hold out set, only relevant for regular FW
%   'record_svd'        = also update the svd for overcomplete methods (don't count the time for this) 
%       Efficiently implemented for GM, Regular FW rules
%       Requires svd() call for InFaceAlternate rule
%   'record_numatoms'   = also update the number of atoms for overcomplete methods (for our method, just reverts to rank)
%   'prox_grad_dual_stop'    = use duality for prox grad stopping
%   'alternate_peak'   = if rank peaks during alternate, change (decrease) tol
%   'prox_grad_peak_tol'    = new tol after rank peaks
%   'test_error_basic' = hold out set from svd
%   'pre_start_full'    = take a full pre-start step
%   'dynamic_denom'     = denominator based on local diameter
%   'opt_before_toward' = do an in-face optimization before every toward step for type 'InFace'
%   'inface_early_toward'   = update lower bound before during the in-face iteration
%   'prox_grad_simplex_euclidean'   = if 1, use Euclidean projection; else, use entropy (only for simplex)
%   'prox_grad_doubling'            = if 1, use doubling strategy for estimating the Lipschitz constant (only for simplex)
%
% history is a structure of algorithm statistics with the following fields:
%   'objvals'               = f(x_k)
%   'lowerbnds'             = B_k
%   'bound_gaps_offset'     = f(x_{k+1}) - B_k
%   'bound_gaps_nooffset'   = f(x_k) - B_k (starts with f(x_{-1}, only place -1 used)
%   'ranks'                 = rank(Z_k)
%   'nucnorms'              = nucnorm(Z_k)
%   'cputimes'              = total time for the algorithm so far
%   'itertypes'             = 
%   'num_iters'             = total number of iterations so far
%   'numatoms'              = num of atoms for Z_k (optional, relevant for atomic methods)
%   'test_set_errors'       = least-squares objective function evaluated on a test set (optional)
%   'regular_cputimes'       = total amount of time spent computing regular Frank-Wolfe directions
%   'alt_cputimes'           = total amount of time spent computing altnerative directions (calling function alt_fun)
%   'update_cputimes'        = total amount of time spent updating SVD/atomic representation (calling function update_representation)
%       Note: with all timings, pre-start time is never counted
%   
%
% dynamic info is useful when optimizing over a sequence of deltas
%   'lowerbnd' = best lower bound found by the algorithm
%   'lowerbnd_sv'    = largest singular value of the gradient (dual norm) at the iterate corresponding to the best lower bound 
%   'warm_start'    = warm start singular vector


%%%% Check input %%%%

if nargin < 2
    error('Need to provide at least 2 inputs');
elseif nargin == 2
    options = struct();
end

% add checks for mat_comp_instance maybe

% set default options
options_use = struct();
options_use.alg_type = 'Regular';
options_use.verbose = 0;
options_use.max_iter = 1000;
options_use.time_limit = 100;
options_use.rel_opt_TOL = 10^-3;
options_use.abs_opt_TOL = 0;
options_use.rank_TOL = 10^-6;
options_use.boundary_TOL = 10^-3;
options_use.alpha_TOL = 10^-8;
options_use.bound_slack = 10^-6;
options_use.gamma_1 = 1;
options_use.gamma_2 = 1;
options_use.last_toward = 0;
options_use.rank_peak = 0;
options_use.rank_stall_thresh = 5;
options_use.svd_options = struct();
options_use.eig_options = struct();
options_use.svdtol_opttol_related = 0;
options_use.prox_grad_iters = 50;
options_use.prox_grad_tol = 10^-3;
options_use.regular_fast = 0;
options_use.hold_out_set_smart = 0;
options_use.record_svd = 0;
options_use.record_numatoms = 0;
options_use.last_toward_emaparam = 1;
options_use.prox_grad_dual_stop = 0;
options_use.alternate_peak = 0;
options_use.prox_grad_peak_tol = 10^-6;
options_use.test_error_basic = 0;
options_use.pre_start_full = 1;
options_use.dynamic_denom = 0;
options_use.opt_before_toward = 0;
options_use.inface_early_toward = 0;
options_use.prox_grad_simplex_euclidean = 0;
options_use.prox_grad_doubling = 0;

% overwrite defaults for things that are set
options_fn = fieldnames(options);
for i = 1:length(options_fn)
    options_use.(options_fn{i}) = options.(options_fn{i});
end

% rename back to options
options = options_use;

% check svd_eig_tol_type
if options.svdtol_opttol_related == 1
    if options.abs_opt_TOL > 0
        options.svd_options.tol = .1*options.abs_opt_TOL;
        options.eig_options.tol = .1*options.abs_opt_TOL;
        options.bound_slack = options.abs_opt_TOL;
    else
        options.svd_options.tol = .01*options.rel_opt_TOL;
        options.eig_options.tol = .01*options.rel_opt_TOL;
        options.bound_slack = options.rel_opt_TOL;
    end
end


%%%% Initialize history %%%%
history = struct();
history.objvals = zeros(options.max_iter + 1, 1);
history.lowerbnds = zeros(options.max_iter + 1, 1);
history.bound_gaps_offset = zeros(options.max_iter + 1, 1); % f(x_{k+1}) - B_k
history.bound_gaps_nooffset = zeros(options.max_iter + 1, 1); % f(x_k) - B_k (starts with f(x_{-1}, only place -1 used)
history.ranks = zeros(options.max_iter + 1, 1);
history.nucnorms = zeros(options.max_iter + 1, 1);
history.cputimes = zeros(options.max_iter + 1, 1);
history.itertypes = cell(options.max_iter + 1, 1);
history.num_iters = options.max_iter + 1;
if options.record_numatoms == 1
    history.numatoms = zeros(options.max_iter + 1, 1);
end
if options.test_error_basic == 1
    history.test_set_errors = zeros(options.max_iter + 1, 1);
end
history.regular_cputimes = zeros(options.max_iter + 1, 1);
history.alt_cputimes = zeros(options.max_iter + 1, 1);
history.update_cputimes = zeros(options.max_iter + 1, 1);

history.prox_grad_not_monotone_flag = 0;
history.prox_grad_iters = zeros(options.max_iter + 1, 1);

%%%% Begin Algorithm %%%%

% Set variables/constants
X_obs_vec = mat_comp_instance.X_obs_vec;
irow = mat_comp_instance.irow;
jcol = mat_comp_instance.jcol;
delta = mat_comp_instance.delta;
no_obs = length(X_obs_vec);
D_bar = 2*delta;
denom_global = 2*D_bar*D_bar;

update_fcn_name = func2str(update_representation);

if nargin < 5
% pre-start
    num_cols = max(jcol);
    options.svd_options.warm_start = rand(num_cols, 1);
    options.svd_options.warm_start = options.svd_options.warm_start/norm(options.svd_options.warm_start, 2);
    
    Zk = struct();
    Zk.vec = zeros(no_obs, 1);
    Zk.U = [];
    Zk.V = [];
    Zk.d = [];
    grad_vec = Zk.vec - X_obs_vec;
    objval = .5*norm(grad_vec, 2)^2;
    if options.hold_out_set_smart == 1
        no_test = length(mat_comp_instance.X_test_vec);
        Zk.test_vec = zeros(no_test, 1);
    end

    [reg_direction_vec, regular_direction_params, lowerbnd, lowerbnd_sv, wolfe_gap_neg] = Regular_FW_direction_sparse(Zk, grad_vec, objval, 0, 0, mat_comp_instance, options);
    options.svd_options.warm_start = regular_direction_params.v_tilde;
    
    if options.pre_start_full == 1
        alpha_k = 1;
    else
        alpha_k = (-wolfe_gap_neg)/(norm(reg_direction_vec, 2)^2);
        alpha_k = min(alpha_k, 1);
    end
    
    Zk.vec = alpha_k*reg_direction_vec;
    Zk = update_representation(Zk, regular_direction_params, alpha_k, options.rank_TOL);
    if options.hold_out_set_smart == 1
        Zk.test_vec = alpha_k*regular_direction_params.test_direction;
    end
    
    grad_vec = Zk.vec - X_obs_vec;
    new_objval = .5*norm(grad_vec, 2)^2;
else
    options.svd_options.warm_start = start_params.warm_start;
    
    Zk = start_params.Z0;
    lowerbnd = start_params.lowerbnd;
    lowerbnd_sv = start_params.lowerbnd_sv;
    
    grad_vec = Zk.vec - X_obs_vec;
    objval = .5*norm(grad_vec, 2)^2;
    new_objval = objval;
end
% [Zk, new_objval (objval), grad_vec, lowerbnd, lowerbnd_sv] are the state of the method
if options.record_svd == 1
    Zk_copy = Zk;
end

% update history
history.bound_gaps_nooffset(1) = objval - lowerbnd;
history.objvals(1) = new_objval;
history.lowerbnds(1) = lowerbnd;
history.bound_gaps_offset(1) = new_objval - lowerbnd;
s_vals = Zk.d;
history.ranks(1) = sum(s_vals > options.rank_TOL);
history.nucnorms(1) = sum(s_vals);
history.cputimes(1) = 0;
history.itertypes{1} = 'regular';
if options.record_numatoms == 1
    history.numatoms(1) = history.ranks(1);
end
if options.test_error_basic == 1
    history.test_set_errors(1) = test_objval(Zk, mat_comp_instance.irow_test, mat_comp_instance.jcol_test, mat_comp_instance.X_test_vec);
end
history.regular_cputimes(1) = 0;
history.alt_cputimes(1) = 0;
history.update_cputimes(1) = 0;
    
% update objval
objval = new_objval;

% heuristics stuff
last_toward_gain_EMA = Inf;

rank_peaked = 0; % has rank peaked yet
current_rank = 1;
current_rank_stall = 0; % how many previous iterations did rank not increase


%%%% Begin Iterations %%%%
for iter = 2:(options.max_iter + 1)
    % start timer
    iteration_timer = tic;
    
    if strcmp(options.alg_type, 'Regular') || (strcmp(options.alg_type, 'InFace') && options.rank_peak == 1 && rank_peaked == 0)
        % do a Regular FW step
        regular_timer = tic;
        [reg_direction_vec, regular_direction_params, lowerbnd, lowerbnd_sv, wolfe_gap_neg] = Regular_FW_direction_sparse(Zk, grad_vec, objval, lowerbnd, lowerbnd_sv, mat_comp_instance, options);
        history.regular_cputimes(iter) = history.regular_cputimes(iter - 1) + toc(regular_timer);
        options.svd_options.warm_start = regular_direction_params.v_tilde;
        
        alpha_k = (-wolfe_gap_neg)/(norm(reg_direction_vec, 2)^2);
        alpha_k = min(alpha_k, 1);
        
        Zk.vec = Zk.vec + alpha_k*reg_direction_vec;
        if options.regular_fast ~= 1
            update_timer = tic;
            Zk = update_representation(Zk, regular_direction_params, alpha_k, options.rank_TOL);
            history.update_cputimes(iter) = history.update_cputimes(iter - 1) + toc(update_timer);
        end
        if options.hold_out_set_smart == 1
            Zk.test_vec = Zk.test_vec + alpha_k*regular_direction_params.test_direction;
        end
        
        grad_vec = Zk.vec - X_obs_vec;
        new_objval = .5*norm(grad_vec, 2)^2;  
        
        %last_toward_gain_print = denom_global/(new_objval - lowerbnd) - denom_global/(objval - lowerbnd)
        history.itertypes{iter} = 'regular';
    elseif strcmp(options.alg_type, 'GM')
        % Guelat-Marcotte decision rule/logic (Algorithm 2 in paper)
        
        % compute away direction
        alt_timer = tic;
        [away_direction_vec, away_direction_params, alpha_full, alpha_partial, away_wolfe_neg, interior_warm_flag] = alt_fun(Zk, grad_vec, irow, jcol, delta, options);
        history.alt_cputimes(iter) = history.alt_cputimes(iter - 1) + toc(alt_timer);
        
        if interior_warm_flag == 1
            options.svd_options.warm_start = away_direction_params.v_away;
        end
        
        % compute regular FW direction
        regular_timer = tic;
        [reg_direction_vec, regular_direction_params, lowerbnd, lowerbnd_sv, reg_wolfe_neg] = Regular_FW_direction_sparse(Zk, grad_vec, objval, lowerbnd, lowerbnd_sv, mat_comp_instance, options);
        history.regular_cputimes(iter) = history.regular_cputimes(iter - 1) + toc(regular_timer);
        
        options.svd_options.warm_start = regular_direction_params.v_tilde;
        
        % do comparison
        if reg_wolfe_neg <= away_wolfe_neg || alpha_full < options_use.alpha_TOL
            % do regular step
            alpha_k = (-reg_wolfe_neg)/(norm(reg_direction_vec, 2)^2);
            alpha_k = min(alpha_k, 1);

            Zk.vec = Zk.vec + alpha_k*reg_direction_vec;
            update_timer = tic;
            Zk = update_representation(Zk, regular_direction_params, alpha_k, options.rank_TOL);
            history.update_cputimes(iter) = history.update_cputimes(iter - 1) + toc(update_timer);
            
            grad_vec = Zk.vec - X_obs_vec;
            new_objval = .5*norm(grad_vec, 2)^2;
            history.itertypes{iter} = 'regular';
        else
            % do away step
            Zk.vec = Zk.vec + alpha_partial*away_direction_vec;
            update_timer = tic;
            Zk = update_representation(Zk, away_direction_params, alpha_partial, options.rank_TOL);
            history.update_cputimes(iter) = history.update_cputimes(iter - 1) + toc(update_timer);
            
            grad_vec = Zk.vec - X_obs_vec;
            new_objval = .5*norm(grad_vec, 2)^2;
            history.itertypes{iter} = 'away';
        end
    elseif strcmp(options.alg_type, 'InFace')
        % In-Face Extended Frank-Wolfe decision rule/logic (Algorithm 3 in paper)
        
        % compute in-face direction and points
        alt_timer = tic;
        [away_direction_vec, away_direction_params, alpha_full, alpha_partial, away_wolfe_neg, interior_warm_flag] = alt_fun(Zk, grad_vec, irow, jcol, delta, options);
        history.alt_cputimes(iter) = history.alt_cputimes(iter - 1) + toc(alt_timer);
        
        if interior_warm_flag == 1 
            options.svd_options.warm_start = away_direction_params.v_away;
        end
        
        if options.inface_early_toward == 1
            regular_timer = tic;
            [reg_direction_vec, regular_direction_params, lowerbnd, lowerbnd_sv, reg_wolfe_neg] = Regular_FW_direction_sparse(Zk, grad_vec, objval, lowerbnd, lowerbnd_sv, mat_comp_instance, options);
            history.regular_cputimes(iter) = history.regular_cputimes(iter - 1) + toc(regular_timer);
            
            options.svd_options.warm_start = regular_direction_params.v_tilde;
        end
        
        Z_full_away_vec = Zk.vec + alpha_full*away_direction_vec;
        grad_vec_full_away = Z_full_away_vec - X_obs_vec;
        objval_full_away = .5*norm(grad_vec_full_away, 2)^2;
        
        if options.dynamic_denom == 1
            denom = away_norm(Zk, away_direction_params, alpha_full);
            denom = 2*denom^2;
            error('do not use');
        else
            denom = denom_global;
        end
        
        recip_diff_full_away = denom/(objval_full_away - lowerbnd) - denom/(objval - lowerbnd);
        
        Z_partial_away_vec = Zk.vec + alpha_partial*away_direction_vec;
        grad_vec_partial_away = Z_partial_away_vec - X_obs_vec;
        objval_partial_away = .5*norm(grad_vec_partial_away, 2)^2;
        recip_diff_partial_away = denom/(objval_partial_away - lowerbnd) - denom/(objval - lowerbnd);
        
        % heuristics
        if options.last_toward == 1
            gamma_1_use = options.gamma_1*last_toward_gain_EMA;
            gamma_2_use = options.gamma_2*last_toward_gain_EMA;
        else
            gamma_1_use = options.gamma_1;
            gamma_2_use = options.gamma_2;
        end
        
        % alpha check
        if alpha_full < options.alpha_TOL
            gamma_1_use = Inf;
            gamma_2_use = Inf;
        end
        
        % do test and update point
        if recip_diff_full_away >= gamma_1_use
            % do full in face
            Zk.vec = Z_full_away_vec;
            update_timer = tic;
            Zk = update_representation(Zk, away_direction_params, alpha_full, options.rank_TOL);
            history.update_cputimes(iter) = history.update_cputimes(iter - 1) + toc(update_timer);
            
            grad_vec = grad_vec_full_away;
            new_objval = objval_full_away;
            history.itertypes{iter} = 'away_full';
        elseif recip_diff_partial_away >= gamma_2_use
            % do partial in face
            Zk.vec = Z_partial_away_vec;
            update_timer = tic;
            Zk = update_representation(Zk, away_direction_params, alpha_partial, options.rank_TOL);
            history.update_cputimes(iter) = history.update_cputimes(iter - 1) + toc(update_timer);
            
            grad_vec = grad_vec_partial_away;
            new_objval = objval_partial_away;
            history.itertypes{iter} = 'away_partial';
        else
            % do regular step
            
            if options.opt_before_toward == 1
                % additional 3 cputimes not implemented here
                [away_direction_vec, away_direction_params, alpha_full, alpha_partial, away_wolfe_neg, interior_warm_flag] = prox_grad_face(Zk, grad_vec, irow, jcol, delta, options);
                if interior_warm_flag == 1
                    options.svd_options.warm_start = away_direction_params.v_away;
                end

                Zk.vec = Zk.vec + alpha_partial*away_direction_vec;
                Zk = update_representation(Zk, away_direction_params, alpha_partial, options.rank_TOL);
                grad_vec = Zk.vec - X_obs_vec;
                new_objval = .5*norm(grad_vec, 2)^2;
                objval = new_objval;
            end
            
            if options.inface_early_toward ~= 1
                regular_timer = tic;
                [reg_direction_vec, regular_direction_params, lowerbnd, lowerbnd_sv, reg_wolfe_neg] = Regular_FW_direction_sparse(Zk, grad_vec, objval, lowerbnd, lowerbnd_sv, mat_comp_instance, options);
                history.regular_cputimes(iter) = history.regular_cputimes(iter - 1) + toc(regular_timer);
                
                options.svd_options.warm_start = regular_direction_params.v_tilde;
            end
            
            alpha_k = (-reg_wolfe_neg)/(norm(reg_direction_vec, 2)^2);
            alpha_k = min(alpha_k, 1);

            Zk.vec = Zk.vec + alpha_k*reg_direction_vec;
            update_timer = tic;
            Zk = update_representation(Zk, regular_direction_params, alpha_k, options.rank_TOL);
            history.update_cputimes(iter) = history.update_cputimes(iter - 1) + toc(update_timer);
            
            grad_vec = Zk.vec - X_obs_vec;
            new_objval = .5*norm(grad_vec, 2)^2; 
            history.itertypes{iter} = 'regular';
            
            % heuristic parameter updating
            if options.last_toward == 1
                last_toward_gain = denom_global/(new_objval - lowerbnd) - denom_global/(objval - lowerbnd);
                if last_toward_gain_EMA == Inf
                    last_toward_gain_EMA = last_toward_gain;
                else
                    last_toward_gain_EMA = (1 - options.last_toward_emaparam)*last_toward_gain_EMA + options.last_toward_emaparam*last_toward_gain;
                end
            end
        end
    elseif strcmp(options.alg_type, 'InFaceAlternate')
        % Alternate between regular Regular Frank-Wolfe steps and in-face optimization (end of section 2 in paper) 
        
        if options.alternate_peak == 1 && rank_peaked == 1
            % adjust prox grad_tolerance
            options.prox_grad_tol = options.prox_grad_peak_tol;
        end
        
        if rem(iter, 2) == 0 || (options.rank_peak == 1 && rank_peaked == 0)
            % regular FW step
            regular_timer = tic;
            [reg_direction_vec, regular_direction_params, lowerbnd, lowerbnd_sv, wolfe_gap_neg] = Regular_FW_direction_sparse(Zk, grad_vec, objval, lowerbnd, lowerbnd_sv, mat_comp_instance, options);
            history.regular_cputimes(iter) = history.regular_cputimes(iter - 1) + toc(regular_timer);
            
            options.svd_options.warm_start = regular_direction_params.v_tilde;

            alpha_k = (-wolfe_gap_neg)/(norm(reg_direction_vec, 2)^2);
            alpha_k = min(alpha_k, 1);

            Zk.vec = Zk.vec + alpha_k*reg_direction_vec;
            update_timer = tic;
            Zk = update_representation(Zk, regular_direction_params, alpha_k, options.rank_TOL);
            history.update_cputimes(iter) = history.update_cputimes(iter - 1) + toc(update_timer);
            
            grad_vec = Zk.vec - X_obs_vec;
            new_objval = .5*norm(grad_vec, 2)^2;
            history.itertypes{iter} = 'regular';            
        else
            % do in-face step
            alt_timer = tic;
            [away_direction_vec, away_direction_params, alpha_full, alpha_partial, away_wolfe_neg, interior_warm_flag] = alt_fun(Zk, grad_vec, irow, jcol, delta, options);
            history.alt_cputimes(iter) = history.alt_cputimes(iter - 1) + toc(alt_timer);
            
            if isfield(away_direction_params, 'not_monotone_flag') && away_direction_params.not_monotone_flag == 1
                history.prox_grad_not_monotone_flag = 1;
            end
            if isfield(away_direction_params, 'total_inner_prox_iters')
                history.prox_grad_iters(iter) = away_direction_params.total_inner_prox_iters;
            end
            if interior_warm_flag == 1
                options.svd_options.warm_start = away_direction_params.v_away;
            end
            
            Zk.vec = Zk.vec + alpha_partial*away_direction_vec;
            update_timer = tic;
            Zk = update_representation(Zk, away_direction_params, alpha_partial, options.rank_TOL);
            history.update_cputimes(iter) = history.update_cputimes(iter - 1) + toc(update_timer);
            
            grad_vec = Zk.vec - X_obs_vec;
            new_objval = .5*norm(grad_vec, 2)^2;
            history.itertypes{iter} = 'in-face';
        end
    else
        error('Enter a valid algorithm type: Regular, GM, or InFace');
    end
    
    % update history
    history.cputimes(iter) = history.cputimes(iter - 1) + toc(iteration_timer); % update cpu time, dont count time for svd of copy variables below
    history.bound_gaps_nooffset(iter) = objval - lowerbnd;
    history.objvals(iter) = new_objval;
    history.lowerbnds(iter) = lowerbnd;
    history.bound_gaps_offset(iter) = new_objval - lowerbnd;
    s_vals = Zk.d;
    history.ranks(iter) = sum(s_vals > options.rank_TOL);
    history.nucnorms(iter) = sum(s_vals);
    if options.test_error_basic == 1
        history.test_set_errors(iter) = test_objval(Zk, mat_comp_instance.irow_test, mat_comp_instance.jcol_test, mat_comp_instance.X_test_vec);
    end
    % check if regular/alt/update have not been updated, then set them to previous
    if history.regular_cputimes(iter) == 0
        history.regular_cputimes(iter) = history.regular_cputimes(iter - 1);
    end
    if history.alt_cputimes(iter) == 0
        history.alt_cputimes(iter) = history.alt_cputimes(iter - 1);
    end
    if history.update_cputimes(iter) == 0
        history.update_cputimes(iter) = history.update_cputimes(iter - 1);
    end
    
    % rank heuristic updating
    if (options.rank_peak == 1 || options.alternate_peak == 1) && rank_peaked == 0
        new_rank = history.ranks(iter);
        if new_rank <= current_rank
            current_rank_stall = current_rank_stall + 1;
            if current_rank_stall >= options.rank_stall_thresh
                rank_peaked = 1;
            end
        else
            current_rank_stall = 0;
        end
        current_rank = new_rank;
    end
    
    if options.record_numatoms == 1
        history.numatoms(iter) = history.ranks(iter);
    end
    
    %%% Logic for dealing with recording a SVD copy of iterates, relevant for atomic methods
    if options.record_svd == 1 && strcmp(options.alg_type, 'Regular')
        Zk_copy = update_svd(Zk_copy, regular_direction_params, alpha_k, options.rank_TOL);
        history.ranks(iter) = sum(Zk_copy.d > options.rank_TOL);
    end
    if options.record_svd == 1 && strcmp(options.alg_type, 'GM')
        if reg_wolfe_neg <= away_wolfe_neg || alpha_full < options_use.alpha_TOL
            Zk_copy = update_svd(Zk_copy, regular_direction_params, alpha_k, options.rank_TOL);
        else
            Zk_copy = update_svd(Zk_copy, away_direction_params, alpha_partial, options.rank_TOL);
        end
        history.ranks(iter) = sum(Zk_copy.d > options.rank_TOL);
    end
    if options.record_svd == 1 && strcmp(options.alg_type, 'InFaceAlternate')
        if rem(iter, 2) == 0 || (options.rank_peak == 1 && rank_peaked == 0)
            % regular FW step
            Zk_copy = update_svd(Zk_copy, regular_direction_params, alpha_k, options.rank_TOL);
        else
            % optimization step
            if strcmp(update_fcn_name, 'update_overcomplete')
                away_direction_params.overcomplete_flag = 1;
                Zk_copy = update_svd(Zk, away_direction_params, alpha_partial, options.rank_TOL);
            elseif strcmp(update_fcn_name, 'update_svd')
                Zk_copy = Zk;
            else
                error('Recording a svd copy is not avaialble for this update type');
            end
        end
        history.ranks(iter) = sum(Zk_copy.d > options.rank_TOL);
    end
        
    % update objval
    objval = new_objval;
        
    % termination checks
    if history.bound_gaps_nooffset(iter)/lowerbnd < options.rel_opt_TOL
        fprintf('Relative Optimality Tolerance Reached at iteration %d\n', iter);
        history.num_iters = iter;
        break;
    end
    if history.bound_gaps_nooffset(iter) < options.abs_opt_TOL || history.objvals(iter - 1) - history.objvals(iter) < options.abs_opt_TOL
        fprintf('Absolute Optimality Tolerance Reached at iteration %d\n', iter);
        history.num_iters = iter;
        break;
    end
    if history.cputimes(iter) > options_use.time_limit
        fprintf('Time Limit Reached at iteration %d\n', iter);
        history.num_iters = iter;
        break; 
    end
    
    if options.verbose == 1
        fprintf('Current Iteration: %d\n', iter);
    end
end

end