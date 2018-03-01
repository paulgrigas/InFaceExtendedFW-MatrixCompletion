function table_instance = add_cogent_table(table_instance)
    mat_comp_instance = table_instance.mat_comp_instance;
    best_lwbnd_val = table_instance.best_lwbnd;
    svt_param = .05*table_instance.delta_found; % changed this from .1 to .05 for try2
    
    [final_soln_cogent_no_svt, history_cogent_no_svt] = call_cogent(mat_comp_instance, -1, best_lwbnd_val);
    [final_soln_cogent_svt, history_cogent_svt] = call_cogent(mat_comp_instance, svt_param, best_lwbnd_val);
    
    table_instance.final_soln_cogent_no_svt = final_soln_cogent_no_svt;
    table_instance.history_cogent_no_svt = history_cogent_no_svt;
    
    table_instance.final_soln_cogent_svt = final_soln_cogent_svt;
    table_instance.history_cogent_svt = history_cogent_svt;
end