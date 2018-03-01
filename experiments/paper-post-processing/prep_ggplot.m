function [iters, cputimes, ranks, nucnorms, log_r_opt_gaps] = prep_ggplot(history, best_lwbnd)
    iters = 1:history.num_iters;
    cputimes = history.cputimes(iters);
    ranks = history.ranks(iters);
    nucnorms = history.nucnorms(iters);
    
    log_r_opt_gaps = (history.objvals(iters) - best_lwbnd*ones(history.num_iters, 1))/best_lwbnd;
    log_r_opt_gaps = log10(log_r_opt_gaps);
end