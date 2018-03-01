function save_ggplot_data(table_instance)
    historyFW = table_instance.historyFW;
    historyIF_11 = table_instance.historyIF_11;
    historyIF_01 = table_instance.historyIF_01;
    historyIF_0Inf = table_instance.historyIF_0Inf;
    %historyIF_early = table_instance.historyIF_early;
    historyIF_peak = table_instance.historyIF_peak;
    historyIF_lasttoward = table_instance.historyIF_lasttoward;
    historyIF_fullopt = table_instance.historyIF_fullopt;
    historyGM = table_instance.historyGM;
    historyGM_atom = table_instance.historyGM_atom;
    
    best_lwbndFW = max(historyFW.lowerbnds(1:historyFW.num_iters));
    best_lwbndIF_11 = max(historyIF_11.lowerbnds(1:historyIF_11.num_iters));
    best_lwbndIF_01 = max(historyIF_01.lowerbnds(1:historyIF_01.num_iters));
    best_lwbndIF_0Inf = max(historyIF_0Inf.lowerbnds(1:historyIF_0Inf.num_iters));
    %best_lwbndIF_early = max(historyIF_early.lowerbnds(1:historyIF_early.num_iters));
    best_lwbndIF_peak = max(historyIF_peak.lowerbnds(1:historyIF_peak.num_iters));
    best_lwbndIF_lasttoward = max(historyIF_lasttoward.lowerbnds(1:historyIF_lasttoward.num_iters));
    best_lwbndIF_fullopt = max(historyIF_fullopt.lowerbnds(1:historyIF_fullopt.num_iters));
    best_lwbndGM = max(historyGM.lowerbnds(1:historyGM.num_iters));
    best_lwbndGM_atom = max(historyGM_atom.lowerbnds(1:historyGM_atom.num_iters));
    
    best_lwbnd = max([best_lwbndFW, best_lwbndIF_11, best_lwbndIF_01, best_lwbndIF_0Inf, best_lwbndIF_peak, best_lwbndIF_lasttoward, best_lwbndIF_fullopt, best_lwbndGM, best_lwbndGM_atom]);

    [itersFW, cputimesFW, ranksFW, nucnormsFW, log_r_opt_gapsFW] = prep_ggplot(historyFW, best_lwbnd);
    [itersIF_11, cputimesIF_11, ranksIF_11, nucnormsIF_11, log_r_opt_gapsIF_11] = prep_ggplot(historyIF_11, best_lwbnd);
    [itersIF_01, cputimesIF_01, ranksIF_01, nucnormsIF_01, log_r_opt_gapsIF_01] = prep_ggplot(historyIF_01, best_lwbnd);
    [itersIF_0Inf, cputimesIF_0Inf, ranksIF_0Inf, nucnormsIF_0Inf, log_r_opt_gapsIF_0Inf] = prep_ggplot(historyIF_0Inf, best_lwbnd);
    [itersIF_peak, cputimesIF_peak, ranksIF_peak, nucnormsIF_peak, log_r_opt_gapsIF_peak] = prep_ggplot(historyIF_peak, best_lwbnd);
    [itersIF_lasttoward, cputimesIF_lasttoward, ranksIF_lasttoward, nucnormsIF_lasttoward, log_r_opt_gapsIF_lasttoward] = prep_ggplot(historyIF_lasttoward, best_lwbnd);
    [itersIF_fullopt, cputimesIF_fullopt, ranksIF_fullopt, nucnormsIF_fullopt, log_r_opt_gapsIF_fullopt] = prep_ggplot(historyIF_fullopt, best_lwbnd);
    [itersGM, cputimesGM, ranksGM, nucnormsGM, log_r_opt_gapsGM] = prep_ggplot(historyGM, best_lwbnd);
    [itersGM_atom, cputimesGM_atom, ranksGM_atom, nucnormsGM_atom, log_r_opt_gapsGM_atom] = prep_ggplot(historyGM_atom, best_lwbnd);
    numatomsGM_atom = historyGM_atom.numatoms(1:historyGM_atom.num_iters);
    
    delta_found = table_instance.delta_found;
    
    save('ggplot_data_big.mat', 'delta_found', 'itersFW', 'cputimesFW', 'ranksFW', 'nucnormsFW', 'log_r_opt_gapsFW', 'itersFW', 'itersIF_11', 'cputimesIF_11', 'ranksIF_11', 'nucnormsIF_11', 'log_r_opt_gapsIF_11', 'itersIF_01', 'cputimesIF_01', 'ranksIF_01', 'nucnormsIF_01', 'log_r_opt_gapsIF_01', 'itersIF_0Inf', 'cputimesIF_0Inf', 'ranksIF_0Inf', 'nucnormsIF_0Inf', 'log_r_opt_gapsIF_0Inf', 'itersIF_peak', 'cputimesIF_peak', 'ranksIF_peak', 'nucnormsIF_peak', 'log_r_opt_gapsIF_peak', 'itersIF_lasttoward', 'cputimesIF_lasttoward', 'ranksIF_lasttoward', 'nucnormsIF_lasttoward', 'log_r_opt_gapsIF_lasttoward', 'itersIF_fullopt', 'cputimesIF_fullopt', 'ranksIF_fullopt', 'nucnormsIF_fullopt', 'log_r_opt_gapsIF_fullopt', 'itersGM', 'cputimesGM', 'ranksGM', 'nucnormsGM', 'log_r_opt_gapsGM', 'itersGM_atom', 'cputimesGM_atom', 'ranksGM_atom', 'nucnormsGM_atom', 'log_r_opt_gapsGM_atom', 'numatomsGM_atom');
end