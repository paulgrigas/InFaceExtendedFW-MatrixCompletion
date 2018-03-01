function [u, d, v] = fast_svds(A, options)
% Returns the leading singular vectors of A
% Fast implmentation from Kim Chuan Toh 
% u = left signular vector
% v = right singular vector
% d = singular value
%
% options:
%   'tol' tolerance parameter
%   'large_thresh' is the threshold for when to stop doing full svd
%   'large_type' is either 'warm' or 'eigs'
%   'warm_start' is the starting iterate for power iteration (right singular vector, v)
%   'maxiter' is the maximum number of iterations

[nrow, ncol] = size(A);

%%%% Options %%%%

if nargin < 2
    options = struct();
end

options_use = struct();
options_use.tol = 1e-10;
options_use.large_thresh = 0;
options_use.large_type = 'eigs';
options_use.maxiter = 300;
options_use.vector_stopping = 0;
options_use.svd_test = 0;

% overwrite defaults for things that are set
options_fn = fieldnames(options);
for i = 1:length(options_fn)
    options_use.(options_fn{i}) = options.(options_fn{i});
end

% rename back to options
options = options_use;

if nrow <= options.large_thresh && ncol <= options.large_thresh
    [U, D, V] = svd(A, 'econ');
    [d, id] = max(diag(D));
    u = U(:, id);
    v = V(:, id);
elseif strcmp(options.large_type, 'eigs')
    try
        opts.issym = 1; opts.isreal = 1; opts.tol = options.tol;
        At = A';

        if (ncol >= nrow)
            fcn = @(x) A*(At*x);
            [u,maxeig] = eigs(fcn,nrow,1,'LM',opts);
            d = sqrt(maxeig);
            v = At*u/d;
        else
            fcn = @(x) At*(A*x);
            [v, maxeig] = eigs(fcn,ncol,1,'LM',opts);
            d = sqrt(maxeig);
            u = A*v/d;
        end
    catch
        disp('eigs did not converge, retrying');
        new_opts = struct();
        new_opts.large_type = 'warm';
        new_opts.maxiter = 5000;
        new_opts.warm_start = randn(ncol, 1);
        new_opts.vector_stopping = 1;
        new_opts.tol = options.tol;
        [u,d,v] = fast_svds(A, new_opts);
    end
elseif strcmp(options.large_type, 'warm')
    %error('do not use');
    
    v1 = options.warm_start;
    NN = options.maxiter;
    tol = options.tol;

    v1 = v1/norm(v1, 2);
    
    u1 = A*v1; 
    u1 = u1/norm(u1, 2);
    
    v1 = A'*u1;
    normv1old =norm(v1, 2);

    v1 = v1/normv1old;

    objold = normv1old;
    v1old = v1;

    for kk = 2:NN

        u1 = A*v1; 
        u1 = u1/norm(u1);

        v1 = A'*u1;
        normv1old =norm(v1);  
        v1 = v1/normv1old;

        objnew = normv1old;
        
        if options.vector_stopping == 1
            if norm(v1 - v1old)/objold <= tol
                %total_iter = kk
                break;
            end
        else
            if ( (objnew - objold)/objold <= tol && abs(objnew - objold) <= tol)
                %total_iter = kk
                break;
            end
        end

        objold = objnew;
        v1old = v1;
    end
    u = u1;
    v = v1;
    d = objnew;
    
    if options.svd_test == 1
        error('slow svd');
        real_d = max(svd(full(A), 'econ'));
        if abs(real_d - d) > 10^-3
            error('fast_svd did not converge to within 10^-3');
        end
    end
else
    error('Enter a valid algorithm type');
end

end