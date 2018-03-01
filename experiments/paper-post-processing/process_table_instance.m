function [avg_alcs, total_times, final_ranks, max_ranks] = process_table_instance(table_instance, final_tol, f_star_gap)
    historyFW = table_instance.historyFW;
    historyIF_11 = table_instance.historyIF_11;
    historyIF_01 = table_instance.historyIF_01;
    historyIF_0Inf = table_instance.historyIF_0Inf;
    historyIF_early = table_instance.historyIF_early;
    historyIF_peak = table_instance.historyIF_peak;
    historyIF_lasttoward = table_instance.historyIF_lasttoward;
    historyIF_fullopt = table_instance.historyIF_fullopt;
    historyGM = table_instance.historyGM;
    historyGM_atom = table_instance.historyGM_atom;
    
    if f_star_gap == 1
        best_lwbndFW = max(historyFW.lowerbnds(1:historyFW.num_iters));
        best_lwbndIF_11 = max(historyIF_11.lowerbnds(1:historyIF_11.num_iters));
        best_lwbndIF_01 = max(historyIF_01.lowerbnds(1:historyIF_01.num_iters));
        best_lwbndIF_0Inf = max(historyIF_0Inf.lowerbnds(1:historyIF_0Inf.num_iters));
        best_lwbndIF_early = max(historyIF_early.lowerbnds(1:historyIF_early.num_iters));
        best_lwbndIF_peak = max(historyIF_peak.lowerbnds(1:historyIF_peak.num_iters));
        best_lwbndIF_lasttoward = max(historyIF_lasttoward.lowerbnds(1:historyIF_lasttoward.num_iters));
        best_lwbndIF_fullopt = max(historyIF_fullopt.lowerbnds(1:historyIF_fullopt.num_iters));
        best_lwbndGM = max(historyGM.lowerbnds(1:historyGM.num_iters));
        best_lwbndGM_atom = max(historyGM_atom.lowerbnds(1:historyGM_atom.num_iters));
        
        best_upbndFW = min(historyFW.objvals(1:historyFW.num_iters));
        best_upbndIF_11 = min(historyIF_11.objvals(1:historyIF_11.num_iters));
        best_upbndIF_01 = min(historyIF_01.objvals(1:historyIF_01.num_iters));
        best_upbndIF_0Inf = min(historyIF_0Inf.objvals(1:historyIF_0Inf.num_iters));
        best_upbndIF_early = min(historyIF_early.objvals(1:historyIF_early.num_iters));
        best_upbndIF_peak = min(historyIF_peak.objvals(1:historyIF_peak.num_iters));
        best_upbndIF_lasttoward = min(historyIF_lasttoward.objvals(1:historyIF_lasttoward.num_iters));
        best_upbndIF_fullopt = min(historyIF_fullopt.objvals(1:historyIF_fullopt.num_iters));
        best_upbndGM = min(historyGM.objvals(1:historyGM.num_iters));
        best_upbndGM_atom = min(historyGM_atom.objvals(1:historyGM_atom.num_iters));

        best_lwbnd = max([best_lwbndFW, best_lwbndIF_11, best_lwbndIF_01, best_lwbndIF_0Inf, best_lwbndIF_early, best_lwbndIF_peak, best_lwbndIF_lasttoward, best_lwbndIF_fullopt, best_lwbndGM, best_lwbndGM_atom])
        [best_upbnd, ind] = min([best_upbndFW, best_upbndIF_11, best_upbndIF_01, best_upbndIF_0Inf, best_upbndIF_early, best_upbndIF_peak, best_upbndIF_lasttoward, best_upbndIF_fullopt, best_upbndGM, best_upbndGM_atom])
        
        bound_diff = best_lwbnd - best_upbnd
        if bound_diff > 0
            error('negative duality gap');
        end
                
        rel_gaps_FW = (historyFW.objvals(1:historyFW.num_iters) - best_lwbnd*ones(historyFW.num_iters, 1))/best_lwbnd;
        rel_gaps_IF_11 = (historyIF_11.objvals(1:historyIF_11.num_iters) - best_lwbnd*ones(historyIF_11.num_iters, 1))/best_lwbnd;
        rel_gaps_IF_01 = (historyIF_01.objvals(1:historyIF_01.num_iters) - best_lwbnd*ones(historyIF_01.num_iters, 1))/best_lwbnd;
        rel_gaps_IF_0Inf = (historyIF_0Inf.objvals(1:historyIF_0Inf.num_iters) - best_lwbnd*ones(historyIF_0Inf.num_iters, 1))/best_lwbnd;
        rel_gaps_IF_early = (historyIF_early.objvals(1:historyIF_early.num_iters) - best_lwbnd*ones(historyIF_early.num_iters, 1))/best_lwbnd;
        rel_gaps_IF_peak = (historyIF_peak.objvals(1:historyIF_peak.num_iters) - best_lwbnd*ones(historyIF_peak.num_iters, 1))/best_lwbnd;
        rel_gaps_IF_lasttoward = (historyIF_lasttoward.objvals(1:historyIF_lasttoward.num_iters) - best_lwbnd*ones(historyIF_lasttoward.num_iters, 1))/best_lwbnd;
        rel_gaps_IF_fullopt = (historyIF_fullopt.objvals(1:historyIF_fullopt.num_iters) - best_lwbnd*ones(historyIF_fullopt.num_iters, 1))/best_lwbnd;
        rel_gaps_GM = (historyGM.objvals(1:historyGM.num_iters) - best_lwbnd*ones(historyGM.num_iters, 1))/best_lwbnd;
        rel_gaps_GM_atom = (historyGM_atom.objvals(1:historyGM_atom.num_iters) - best_lwbnd*ones(historyGM_atom.num_iters, 1))/best_lwbnd;
    else
        rel_gaps_FW = historyFW.bound_gaps_nooffset(1:historyFW.num_iters)./historyFW.lowerbnds(1:historyFW.num_iters);
        rel_gaps_IF_11 = historyIF_11.bound_gaps_nooffset(1:historyIF_11.num_iters)./historyIF_11.lowerbnds(1:historyIF_11.num_iters);
        rel_gaps_IF_01 = historyIF_01.bound_gaps_nooffset(1:historyIF_01.num_iters)./historyIF_01.lowerbnds(1:historyIF_01.num_iters);
        rel_gaps_IF_0Inf = historyIF_0Inf.bound_gaps_nooffset(1:historyIF_0Inf.num_iters)./historyIF_0Inf.lowerbnds(1:historyIF_0Inf.num_iters);
        rel_gaps_IF_early = historyIF_early.bound_gaps_nooffset(1:historyIF_early.num_iters)./historyIF_early.lowerbnds(1:historyIF_early.num_iters);
        rel_gaps_IF_peak = historyIF_peak.bound_gaps_nooffset(1:historyIF_peak.num_iters)./historyIF_peak.lowerbnds(1:historyIF_peak.num_iters);
        rel_gaps_IF_lasttoward = historyIF_lasttoward.bound_gaps_nooffset(1:historyIF_lasttoward.num_iters)./historyIF_lasttoward.lowerbnds(1:historyIF_lasttoward.num_iters);
        rel_gaps_IF_fullopt = historyIF_fullopt.bound_gaps_nooffset(1:historyIF_fullopt.num_iters)./historyIF_fullopt.lowerbnds(1:historyIF_fullopt.num_iters);
        rel_gaps_GM = historyGM.bound_gaps_nooffset(1:historyGM.num_iters)./historyGM.lowerbnds(1:historyGM.num_iters);
        rel_gaps_GM_atom = historyGM_atom.bound_gaps_nooffset(1:historyGM_atom.num_iters)./historyGM_atom.lowerbnds(1:historyGM_atom.num_iters);
    end
    
    % check that we reached relative optimality final_tol (final_tol) at the end of each method
    final_rel_gaps = [rel_gaps_FW(historyFW.num_iters); rel_gaps_IF_11(historyIF_11.num_iters); rel_gaps_IF_01(historyIF_01.num_iters); rel_gaps_IF_0Inf(historyIF_0Inf.num_iters); rel_gaps_IF_early(historyIF_early.num_iters); rel_gaps_IF_peak(historyIF_peak.num_iters); rel_gaps_IF_lasttoward(historyIF_lasttoward.num_iters); rel_gaps_IF_fullopt(historyIF_fullopt.num_iters); rel_gaps_GM(historyGM.num_iters); rel_gaps_GM_atom(historyGM_atom.num_iters)]
    test_rel_gaps = final_rel_gaps < final_tol
    
    if min(test_rel_gaps) < 1
        disp('some method did not converge to final_tol');
    end
    
    
    % calculate area under curve
    avg_alc_FW = avg_ALC(rel_gaps_FW, historyFW);
    avg_alc_IF_11 = avg_ALC(rel_gaps_IF_11, historyIF_11);
    avg_alc_IF_01 = avg_ALC(rel_gaps_IF_01, historyIF_01);
    avg_alc_IF_0Inf = avg_ALC(rel_gaps_IF_0Inf, historyIF_0Inf);
    avg_alc_IF_early = avg_ALC(rel_gaps_IF_early, historyIF_early);
    avg_alc_IF_peak = avg_ALC(rel_gaps_IF_peak, historyIF_peak);
    avg_alc_IF_lasttoward = avg_ALC(rel_gaps_IF_lasttoward, historyIF_lasttoward);
    avg_alc_IF_fullopt = avg_ALC(rel_gaps_IF_fullopt, historyIF_fullopt);
    avg_alc_IF_GM = avg_ALC(rel_gaps_GM, historyGM);
    avg_alc_IF_GM_atom = avg_ALC(rel_gaps_GM_atom, historyGM_atom);
    
    avg_alcs = [avg_alc_FW; avg_alc_IF_11; avg_alc_IF_01; avg_alc_IF_0Inf; avg_alc_IF_early; avg_alc_IF_peak; avg_alc_IF_lasttoward; avg_alc_IF_fullopt; avg_alc_IF_GM; avg_alc_IF_GM_atom];
    
    % calcuate finals
    
    FW_ind = find(rel_gaps_FW < final_tol, 1); 
    if isempty(FW_ind)
        FW_ind = historyFW.num_iters;
    end
    IF_11_ind = find(rel_gaps_IF_11 < final_tol, 1);
    if isempty(IF_11_ind)
        IF_11_ind = historyIF_11.num_iters;
    end
    IF_01_ind = find(rel_gaps_IF_01 < final_tol, 1);
    if isempty(IF_01_ind)
        IF_01_ind = historyIF_01.num_iters;
    end
    IF_0Inf_ind = find(rel_gaps_IF_0Inf < final_tol, 1);
    if isempty(IF_0Inf_ind)
        IF_0Inf_ind = historyIF_0Inf.num_iters;
    end
    IF_early_ind = find(rel_gaps_IF_early < final_tol, 1);
    if isempty(IF_early_ind)
        IF_early_ind = historyIF_early.num_iters;
    end
    IF_peak_ind = find(rel_gaps_IF_peak < final_tol, 1);
    if isempty(IF_peak_ind)
        IF_peak_ind = historyIF_peak.num_iters;
    end
    IF_lasttoward_ind = find(rel_gaps_IF_lasttoward < final_tol, 1);
    if isempty(IF_lasttoward_ind)
        IF_lasttoward_ind = historyIF_lasttoward.num_iters;
    end
    IF_fullopt_ind = find(rel_gaps_IF_fullopt < final_tol, 1);
    if isempty(IF_fullopt_ind)
        IF_fullopt_ind = historyIF_fullopt.num_iters;
    end
    GM_ind = find(rel_gaps_GM < final_tol, 1);
    if isempty(GM_ind)
        GM_ind = historyGM.num_iters;
    end
    GM_atom_ind = find(rel_gaps_GM_atom < final_tol, 1);
    if isempty(GM_atom_ind)
        GM_atom_ind = historyGM_atom.num_iters;
    end
    
    
    total_time_FW = historyFW.cputimes(FW_ind);
    total_time_IF_11 = historyIF_11.cputimes(IF_11_ind);
    total_time_IF_01 = historyIF_01.cputimes(IF_01_ind);
    total_time_IF_0Inf = historyIF_0Inf.cputimes(IF_0Inf_ind);
    total_time_IF_early = historyIF_early.cputimes(IF_early_ind);
    total_time_IF_peak = historyIF_peak.cputimes(IF_peak_ind);
    total_time_lasttoward = historyIF_lasttoward.cputimes(IF_lasttoward_ind);
    total_time_IF_fullopt = historyIF_fullopt.cputimes(IF_fullopt_ind);
    total_time_GM = historyGM.cputimes(GM_ind);
    total_time_GM_atom = historyGM_atom.cputimes(GM_atom_ind);
    
    total_times = [total_time_FW; total_time_IF_11; total_time_IF_01; total_time_IF_0Inf; total_time_IF_early; total_time_IF_peak; total_time_lasttoward; total_time_IF_fullopt; total_time_GM; total_time_GM_atom];
    
    
    
    
    final_rank_FW = historyFW.ranks(FW_ind);
    final_rank_IF_11 = historyIF_11.ranks(IF_11_ind);
    final_rank_IF_01 = historyIF_01.ranks(IF_01_ind);
    final_rank_IF_0Inf = historyIF_0Inf.ranks(IF_0Inf_ind);
    final_rank_IF_early = historyIF_early.ranks(IF_early_ind);
    final_rank_IF_peak = historyIF_peak.ranks(IF_peak_ind);
    final_rank_lasttoward = historyIF_lasttoward.ranks(IF_lasttoward_ind);
    final_rank_IF_fullopt = historyIF_fullopt.ranks(IF_fullopt_ind);
    final_rank_GM = historyGM.ranks(GM_ind);
    final_rank_GM_atom = historyGM_atom.ranks(GM_atom_ind);
    
    final_ranks = [final_rank_FW; final_rank_IF_11; final_rank_IF_01; final_rank_IF_0Inf; final_rank_IF_early; final_rank_IF_peak; final_rank_lasttoward; final_rank_IF_fullopt; final_rank_GM; final_rank_GM_atom];
    
    max_rank_FW = max(historyFW.ranks);
    max_rank_IF_11 = max(historyIF_11.ranks);
    max_rank_IF_01 = max(historyIF_01.ranks);
    max_rank_IF_0Inf = max(historyIF_0Inf.ranks);
    max_rank_IF_early = max(historyIF_early.ranks);
    max_rank_IF_peak = max(historyIF_peak.ranks);
    max_rank_IF_lasttoward = max(historyIF_lasttoward.ranks);
    max_rank_IF_fullopt = max(historyIF_fullopt.ranks);
    max_rank_GM = max(historyGM.ranks);
    max_rank_GM_atom = max(historyGM_atom.ranks);
    
    max_ranks = [max_rank_FW; max_rank_IF_11; max_rank_IF_01; max_rank_IF_0Inf; max_rank_IF_early; max_rank_IF_peak; max_rank_IF_lasttoward; max_rank_IF_fullopt; max_rank_GM; max_rank_GM_atom];
end