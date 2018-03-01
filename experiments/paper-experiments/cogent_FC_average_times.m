final_tol = 10^-2.5;

for i = 1:3
    clearvars -except i final_tol;
    load_string = sprintf('ex%d_small_updated_FCcogent_july2.mat', i);
    load(load_string);
    
    FC_times = zeros(25, 1);
    Cogent_no_svt_times = zeros(25, 1);
    Cogent_svt_times = zeros(25, 1);
    
    for j = 1:25
        t_inst = table_instances{j};
        best_lwbnd = t_inst.best_lwbnd;
        history_fullopt_atom = t_inst.history_fullopt_atom;
        history_cogent_no_svt = t_inst.history_cogent_no_svt;
        history_cogent_svt = t_inst.history_cogent_svt;
        
        rel_gaps_FC = (history_fullopt_atom.objvals(1:history_fullopt_atom.num_iters) - best_lwbnd*ones(history_fullopt_atom.num_iters, 1))/best_lwbnd;
        rel_gaps_cogent_no_svt = (history_cogent_no_svt.objvals(1:history_cogent_no_svt.num_iters) - best_lwbnd*ones(history_cogent_no_svt.num_iters, 1))/best_lwbnd;
        rel_gaps_cogent_svt = (history_cogent_svt.objvals(1:history_cogent_svt.num_iters) - best_lwbnd*ones(history_cogent_svt.num_iters, 1))/best_lwbnd;
        
        FC_ind = find(rel_gaps_FC < final_tol, 1);
        if isempty(FC_ind)
            disp('FC hit the time limit...');
            FC_ind = history_fullopt_atom.num_iters;
        end
        
        Cogent_no_svt_ind = find(rel_gaps_cogent_no_svt < final_tol, 1);
        Cogent_svt_ind = find(rel_gaps_cogent_svt < final_tol, 1);
        
        FC_times(j) = history_fullopt_atom.cputimes(FC_ind);
        Cogent_no_svt_times(j) = history_cogent_no_svt.cputimes(Cogent_no_svt_ind);
        Cogent_svt_times(j) = history_cogent_svt.cputimes(Cogent_svt_ind);
    end
    
    fprintf(load_string);
    fprintf('\n');
    average_FC = mean(FC_times)
    average_cogent_no_svt = mean(Cogent_no_svt_times)
    average_cogent_svt = mean(Cogent_svt_times)
end