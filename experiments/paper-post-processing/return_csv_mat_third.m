function CSV_mat = return_csv_mat_third(table_instances, num_trials)
total_iters_25 = zeros(9, num_trials);
total_time_25 = zeros(9, num_trials);
total_regular_25 = zeros(9, num_trials);
total_interior_away_25 = zeros(9, num_trials);
total_boundary_partial_25 = zeros(9, num_trials);
total_boundary_full_25 = zeros(9, num_trials);
final_rank_25 = zeros(9, num_trials);
rank_ub_25 = zeros(9, num_trials);
rank_raio_25 = zeros(9, num_trials);
work_ratio_25 = zeros(9, num_trials);
time_percent_IF_25 = zeros(9, num_trials);
time_percent_regular_25 = zeros(9, num_trials);


for i = 1:num_trials
    table_instance = table_instances{i};
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
    
    history_fullopt_atom = table_instance.history_fullopt_atom;
    
    
    % use the same best lwbnd from before
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
    best_lwbnd = max([best_lwbndFW, best_lwbndIF_11, best_lwbndIF_01, best_lwbndIF_0Inf, best_lwbndIF_early, best_lwbndIF_peak, best_lwbndIF_lasttoward, best_lwbndIF_fullopt, best_lwbndGM, best_lwbndGM_atom]);

    
    for j = 1:9
        if j == 1
            history_cur = historyFW;
        elseif j == 2
            history_cur = historyIF_11;
        elseif j == 3
            history_cur = historyIF_01;
        elseif j == 4
            history_cur = historyIF_0Inf;
        elseif j == 5
            history_cur = historyIF_fullopt;
        elseif j == 6
            history_cur = historyIF_peak;
        elseif j == 7
           history_cur = historyGM;
        elseif j == 8
            history_cur = historyGM_atom;
        elseif j == 9
            history_cur = history_fullopt_atom;
        end
        
        [total_iters_25(j,i), total_time_25(j,i), total_regular_25(j,i), total_interior_away_25(j,i), total_boundary_partial_25(j,i), total_boundary_full_25(j,i), final_rank_25(j,i), rank_ub_25(j,i), rank_raio_25(j,i), work_ratio_25(j,i), time_percent_IF_25(j,i), time_percent_regular_25(j,i)] = process_third_table(history_cur, 10^-2.5, best_lwbnd);        
    end
end
avg_total_iters = mean(total_iters_25, 2);
avg_total_time = mean(total_time_25, 2);
avg_total_regular = mean(total_regular_25, 2);
avg_total_interior_away = mean(total_interior_away_25, 2);
avg_total_boundary_partial = mean(total_boundary_partial_25, 2);
avg_total_boundary_full = mean(total_boundary_full_25, 2);
avg_final_rank = mean(final_rank_25, 2);
avg_rank_ub = mean(rank_ub_25, 2);
avg_rank_raio = mean(rank_raio_25, 2);
avg_work_ratio = mean(work_ratio_25, 2);
avg_time_percent_IF = mean(time_percent_IF_25, 2);
avg_time_percent_regular = mean(time_percent_regular_25, 2);

CSV_mat = [avg_total_iters'; avg_total_time'; avg_total_regular'; avg_total_interior_away'; avg_total_boundary_partial'; avg_total_boundary_full'; avg_final_rank'; avg_rank_ub'; avg_rank_raio'; avg_work_ratio'; avg_time_percent_IF'; avg_time_percent_regular'];

end