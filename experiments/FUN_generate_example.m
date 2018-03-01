function [no_obs, Omega, irow, jcol, Xobs_vec, Z_star] = FUN_generate_example(nrow, ncol, rnkPOP, propobs, SNR, options)
    options_use = struct();
    options_use.return_zstar = 0;
    options_use.normalize = 0;

    % overwrite defaults for things that are set
    options_fn = fieldnames(options);
    for i = 1:length(options_fn)
        options_use.(options_fn{i}) = options.(options_fn{i});
    end
    
    % rename back to options
    options = options_use;
    
    %%%%% Begin algorithm %%%%%%

    F=rand(nrow*ncol,1); [Omega, vals]= find(F <= propobs); [irow,jcol]=ind2sub([nrow,ncol],Omega);

    no_obs = length(Omega);
  
    uu=randn(nrow,rnkPOP); vv=randn(ncol,rnkPOP);
    NSE=randn(nrow,ncol); 
    X_pop=uu*vv';  X_pop = X_pop / norm(X_pop, 'fro');


    normNSE= norm(NSE,'fro');
    X_mat_whole= X_pop + (NSE/(SNR*normNSE));

    Xobs_vec= X_mat_whole(Omega); %% vector of observed ratings, Omega are the ids corresp to obs. entries
    
    if options.normalize == 1
        norm_const = norm(Xobs_vec, 2);
        Xobs_vec = Xobs_vec/norm_const;
    end
    
    if options.return_zstar == 1
        Z_star = struct();
        [ZU, ZD, ZV] = svd(X_pop, 'econ');
        [ZU, ZD, ZV] = thinSVD(ZU, ZD, ZV, 10^-6);
        Z_star.U = ZU;
        Z_star.V = ZV;
        
        if options.normalize == 1
            Z_star.d = diag(ZD)/norm_const;
        else
            Z_star.d = diag(ZD);
        end
    else
        Z_star = [];
    end
end