function [v, d] = fast_eigs(A, options)
% assumes the matrix A is symmetirc (not necessarily PSD) and we want the largest/smallest eigenvalue
% i.e. not necessarily the largest magnitude eigenvalue
%
% options:
%   'tol' tolerance parameter
%   'large_thresh' is the threshold for when to stop doing full eigendecomposition
%   'large_type' is either 'warm' or 'eigs' ONLY eigs for now
%   'warm_start' is the starting iterate for power iteration
%   'minmax_type' is either 'max' (largest) or 'min' (smallest)


[nrow, ncol] = size(A);

%%%% Options %%%%

options_use = struct();
options_use.tol = 1e-10;
options_use.large_thresh = 200;
options_use.large_type = 'eigs';
options_use.minmax_type = 'max';

% overwrite defaults for things that are set
options_fn = fieldnames(options);
for i = 1:length(options_fn)
    options_use.(options_fn{i}) = options.(options_fn{i});
end

% rename back to options
options = options_use;


%%%% Method %%%%

if nrow <= options.large_thresh && ncol <= options.large_thresh
    % do full decomposition
    [V, D] = eig(A);
    if strcmp(options.minmax_type, 'max')
        [d, id] = max(diag(D));
    elseif strcmp(options.minmax_type, 'min')
        [d, id] = min(diag(D));
    else
        error('Enter a valid minmax type');
    end
    v = V(:, id);
else
    if strcmp(options.large_type, 'eigs')
        opts.issym = 1; opts.isreal = 1; opts.tol = options.tol;
        if strcmp(options.minmax_type, 'max')
            [v,d] = eigs(@(x) A*x, nrow, 1, 'LA', opts);
        elseif strcmp(options.minmax_type, 'min')
            [v,d] = eigs(@(x) A*x, nrow, 1, 'SA', opts);
        else
            error('Enter a valid minmax type');
        end
    elseif strcmp(options.large_type, 'warm')
        error('Warm start not implemented');
    else
        error('Enter a valid algorithm type');
    end
end

end