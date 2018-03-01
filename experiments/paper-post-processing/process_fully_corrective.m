final_tol = 10^-2.5;

for i = 1:8
    clearvars -except i final_tol;
    
    load_string = sprintf('ex%d_big_updated_FC_july2.mat', i);
    load(load_string);
    
    history_fullopt_atom = table_instance.history_fullopt_atom;
    best_lwbnd = table_instance.best_lwbnd;
    best_lwbnd2 = table_instances{1}.best_lwbnd;
    if best_lwbnd ~= best_lwbnd2
        error('oh no');
    end
    
    if history_fullopt_atom.prox_grad_not_monotone_flag == 1
        error('not monotone');
    end
    
    rel_gaps_fullopt_atom = (history_fullopt_atom.objvals(1:history_fullopt_atom.num_iters) - best_lwbnd*ones(history_fullopt_atom.num_iters, 1))/best_lwbnd;
    fullopt_atom_ind = find(rel_gaps_fullopt_atom < final_tol, 1);
    if isempty(fullopt_atom_ind)
        fullopt_atom_ind = history_fullopt_atom.num_iters;
    end
    
    fprintf(strcat(load_string, '\n'));
    delta = table_instance.delta_found
    total_time_fullopt_atom = history_fullopt_atom.cputimes(fullopt_atom_ind)
    final_rank_fullopt_atom = history_fullopt_atom.ranks(fullopt_atom_ind)
    max_rank_fullopt_atom = max(history_fullopt_atom.ranks(1:fullopt_atom_ind))
    prox_grad_not_monotone = table_instance.history_fullopt_atom.prox_grad_not_monotone_flag
end