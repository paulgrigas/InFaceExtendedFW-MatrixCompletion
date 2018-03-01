function drawPlots(historyFW, historyGM, historyIF)
    figure
    plot(1:historyFW.num_iters, historyFW.ranks(1:historyFW.num_iters), 'r', 1:historyGM.num_iters, historyGM.ranks(1:historyGM.num_iters), 'g', 1:historyIF.num_iters, historyIF.ranks(1:historyIF.num_iters), 'k')
    title('Rank vs. Iterations')
    
    figure
    plot(1:historyFW.num_iters, historyFW.nucnorms(1:historyFW.num_iters), 'r', 1:historyGM.num_iters, historyGM.nucnorms(1:historyGM.num_iters), 'g', 1:historyIF.num_iters, historyIF.nucnorms(1:historyIF.num_iters), 'k')
    title('Nuclear Norm vs. Iterations')

    best_lwbndFW = max(historyFW.lowerbnds(1:historyFW.num_iters));
    best_lwbndGM = max(historyGM.lowerbnds(1:historyGM.num_iters));
    best_lwbndIF = max(historyIF.lowerbnds(1:historyIF.num_iters));
    best_lwbnd = max([best_lwbndFW, best_lwbndGM, best_lwbndIF])
    
    r_opt_gaps_FW = (historyFW.objvals(1:historyFW.num_iters) - best_lwbnd*ones(historyFW.num_iters, 1))/best_lwbnd;
    r_opt_gaps_GM = (historyGM.objvals(1:historyGM.num_iters) - best_lwbnd*ones(historyGM.num_iters, 1))/best_lwbnd;
    r_opt_gaps_IF = (historyIF.objvals(1:historyIF.num_iters) - best_lwbnd*ones(historyIF.num_iters, 1))/best_lwbnd;
    
    figure
    plot(historyFW.cputimes(1:historyFW.num_iters), log10(r_opt_gaps_FW), 'r', historyGM.cputimes(1:historyGM.num_iters), log10(r_opt_gaps_GM), 'g', historyIF.cputimes(1:historyIF.num_iters), log10(r_opt_gaps_IF), 'k')
    title('Log10 Relative Optimality Gap vs. CPU Time')
    
    IF_rel_FW = min(historyIF.objvals(1:historyIF.num_iters))/min(historyFW.objvals(1:historyFW.num_iters))
    GM_rel_FW = min(historyGM.objvals(1:historyGM.num_iters))/min(historyFW.objvals(1:historyFW.num_iters))
    IF_rel_GM = min(historyIF.objvals(1:historyIF.num_iters))/min(historyIF.objvals(1:historyIF.num_iters))
    
    % plots relative to FW as a function of CPU time, i.e., best iterate found in that CPU time
    
end