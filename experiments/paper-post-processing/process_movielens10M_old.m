best_lwbndFW = max(historyFW.lowerbnds(1:historyFW.num_iters));
best_lwbndIF_0Inf = max(historyIF_0Inf.lowerbnds(1:historyIF_0Inf.num_iters));
%best_lwbndIF_fullopt = max(historyIF_fullopt.lowerbnds(1:historyIF_fullopt.num_iters));
best_lwbnd = max([best_lwbndFW, best_lwbndIF_0Inf]);

rel_gaps_FW = (historyFW.objvals(1:historyFW.num_iters) - best_lwbnd*ones(historyFW.num_iters, 1))/best_lwbnd;
rel_gaps_IF_0Inf = (historyIF_0Inf.objvals(1:historyIF_0Inf.num_iters) - best_lwbnd*ones(historyIF_0Inf.num_iters, 1))/best_lwbnd;
%rel_gaps_IF_fullopt = (historyIF_fullopt.objvals(1:historyIF_fullopt.num_iters) - best_lwbnd*ones(historyIF_fullopt.num_iters, 1))/best_lwbnd;

delta = mat_comp_instance.delta;
m_size = max(mat_comp_instance.irow);
n_size = max(mat_comp_instance.jcol);
percent_obs = 10000000/(m_size*n_size);


rel_gaps = [10^-1.5; 10^-2; 10^-2.25; 10^-2.5];
num_gaps = length(rel_gaps);
table_mat = zeros(4, 5);
for i = 1:num_gaps
    final_tol = rel_gaps(i);
    FW_ind = find(rel_gaps_FW < final_tol, 1);
    IF_0Inf_ind = find(rel_gaps_IF_0Inf < final_tol, 1);
    if isempty(FW_ind)
        FW_ind = 1;
    end
    total_time_FW = historyFW.cputimes(FW_ind)/60;
    total_time_IF_0Inf = historyIF_0Inf.cputimes(IF_0Inf_ind)/60;
    final_rank_FW = historyFW.ranks(FW_ind);
    final_rank_IF_0Inf = historyIF_0Inf.ranks(IF_0Inf_ind);
    table_mat(i, :) = [rel_gaps(i), total_time_FW, final_rank_FW, total_time_IF_0Inf, final_rank_IF_0Inf];
end

fileId = fopen('movie_table.txt', 'w');

for i = 1:4
    fprintf(fileId, '%0.2f & & %0.2f & %d & & %0.2f & %d \\\\ \n', table_mat(i,:)');
end

fclose(fileId);