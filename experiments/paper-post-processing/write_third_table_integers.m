fileId = fopen('third_table.txt', 'w');
fprintf(fileId, ' & & & & & & & & & & \\\\ \n ');

load('ex1_small_updated_july_third_table_v2.mat');
CSV_mat = return_csv_mat_third(new_table_instances, num_trials);
rank_mat = CSV_mat(7:8, :); rank_mat = rank_mat(:);

delta_sum = 0;
for i = 1:num_trials
    delta_sum = delta_sum + table_instances{i}.delta_found;
end
delta = delta_sum/num_trials;

fprintf(fileId, '$ m = %d, n = %d, \\rho = %8.2f $ & & Total CPU Time & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', m_size, n_size, percent_obs, CSV_mat(2,:));
fprintf(fileId, '$ r = %d, \\text{SNR} = %d, \\delta_{\\text{avg}} = %8.2f $ & & Total Iters & %d & & %d & %d & %d & %d & %d & & %d & %d & & %d \\\\ \n', true_rank, SNR, delta, round(CSV_mat(1,:)));
fprintf(fileId, ' & & Total Regular Steps & %d & & %d & %d & %d & %d & %d & & %d & %d & & %d \\\\ \n', round(CSV_mat(3,:)));
fprintf(fileId, ' & & Total Interior Away Steps & %d & & %d & %d & %d & %d & %d & & %d & %d & & %d \\\\ \n', round(CSV_mat(4,:)));
fprintf(fileId, ' & & Total Partial IF Steps & %d & & %d & %d & %d & %d & %d & & %d & %d & & %d \\\\ \n', round(CSV_mat(5,:)));
fprintf(fileId, ' & & Total Full IF Steps & %d & & %d & %d & %d & %d & %d & & %d & %d & & %d \\\\ \n', round(CSV_mat(6,:)));
fprintf(fileId, ' & & Final Rank (Final Rank UB) & %d (%d) & & %d (%d) & %d (%d) & %d (%d) & %d (%d) & %d (%d) & & %d (%d) & %d (%d) & & %d (%d) \\\\ \n', round(rank_mat));
fprintf(fileId, ' & & Final Rank/Final Upper Bound & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(9,:));
fprintf(fileId, ' & & Percent Time Computing IF Directions & %8.2f\\%% & & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & & %8.2f\\%% & %8.2f\\%% & & %8.2f\\%% \\\\ \n', 100*CSV_mat(11,:));
fprintf(fileId, ' & & Percent Time Computing Regular Directions & %8.2f\\%% & & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & & %8.2f\\%% & %8.2f\\%% & & %8.2f\\%% \\\\ \n', 100*CSV_mat(12,:));
fprintf(fileId, ' & & Avg. IF Computation Time/Avg. Regular Computation Time & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(10,:));
fprintf(fileId, ' & & Avg. Regular Computation Time/Avg. IF Computation Time & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \\\\ \n', 1./CSV_mat(10,:));

%d (%d) & & %d (%d) & %d (%d) & %d (%d) & %d (%d) & %d (%d) & & %d (%d) & %d (%d)







clear;
fileId = fopen('third_table.txt', 'a');
load('ex2_small_updated_july_third_table_v2.mat');
CSV_mat = return_csv_mat_third(new_table_instances, num_trials);
rank_mat = CSV_mat(7:8, :); rank_mat = rank_mat(:);

delta_sum = 0;
for i = 1:num_trials
    delta_sum = delta_sum + table_instances{i}.delta_found;
end
delta = delta_sum/num_trials;

fprintf(fileId, '$ m = %d, n = %d, \\rho = %8.2f $ & & Total CPU Time & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', m_size, n_size, percent_obs, CSV_mat(2,:));
fprintf(fileId, '$ r = %d, \\text{SNR} = %d, \\delta_{\\text{avg}} = %8.2f $ & & Total Iters & %d & & %d & %d & %d & %d & %d & & %d & %d & & %d \\\\ \n', true_rank, SNR, delta, round(CSV_mat(1,:)));
fprintf(fileId, ' & & Total Regular Steps & %d & & %d & %d & %d & %d & %d & & %d & %d & & %d \\\\ \n', round(CSV_mat(3,:)));
fprintf(fileId, ' & & Total Interior Away Steps & %d & & %d & %d & %d & %d & %d & & %d & %d & & %d \\\\ \n', round(CSV_mat(4,:)));
fprintf(fileId, ' & & Total Partial IF Steps & %d & & %d & %d & %d & %d & %d & & %d & %d & & %d \\\\ \n', round(CSV_mat(5,:)));
fprintf(fileId, ' & & Total Full IF Steps & %d & & %d & %d & %d & %d & %d & & %d & %d & & %d \\\\ \n', round(CSV_mat(6,:)));
fprintf(fileId, ' & & Final Rank (Final Rank UB) & %d (%d) & & %d (%d) & %d (%d) & %d (%d) & %d (%d) & %d (%d) & & %d (%d) & %d (%d) & & %d (%d) \\\\ \n', round(rank_mat));
fprintf(fileId, ' & & Final Rank/Final Upper Bound & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(9,:));
fprintf(fileId, ' & & Percent Time Computing IF Directions & %8.2f\\%% & & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & & %8.2f\\%% & %8.2f\\%% & & %8.2f\\%% \\\\ \n', 100*CSV_mat(11,:));
fprintf(fileId, ' & & Percent Time Computing Regular Directions & %8.2f\\%% & & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & & %8.2f\\%% & %8.2f\\%% & & %8.2f\\%% \\\\ \n', 100*CSV_mat(12,:));
fprintf(fileId, ' & & Avg. IF Computation Time/Avg. Regular Computation Time & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(10,:));
fprintf(fileId, ' & & Avg. Regular Computation Time/Avg. IF Computation Time & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \\\\ \n', 1./CSV_mat(10,:));



clear;
fileId = fopen('third_table.txt', 'a');
load('ex3_small_updated_july_third_table_v2.mat');
CSV_mat = return_csv_mat_third(new_table_instances, num_trials);
rank_mat = CSV_mat(7:8, :); rank_mat = rank_mat(:);

delta_sum = 0;
for i = 1:num_trials
    delta_sum = delta_sum + table_instances{i}.delta_found;
end
delta = delta_sum/num_trials;

fprintf(fileId, '$ m = %d, n = %d, \\rho = %8.2f $ & & Total CPU Time & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', m_size, n_size, percent_obs, CSV_mat(2,:));
fprintf(fileId, '$ r = %d, \\text{SNR} = %d, \\delta_{\\text{avg}} = %8.2f $ & & Total Iters & %d & & %d & %d & %d & %d & %d & & %d & %d & & %d \\\\ \n', true_rank, SNR, delta, round(CSV_mat(1,:)));
fprintf(fileId, ' & & Total Regular Steps & %d & & %d & %d & %d & %d & %d & & %d & %d & & %d \\\\ \n', round(CSV_mat(3,:)));
fprintf(fileId, ' & & Total Interior Away Steps & %d & & %d & %d & %d & %d & %d & & %d & %d & & %d \\\\ \n', round(CSV_mat(4,:)));
fprintf(fileId, ' & & Total Partial IF Steps & %d & & %d & %d & %d & %d & %d & & %d & %d & & %d \\\\ \n', round(CSV_mat(5,:)));
fprintf(fileId, ' & & Total Full IF Steps & %d & & %d & %d & %d & %d & %d & & %d & %d & & %d \\\\ \n', round(CSV_mat(6,:)));
fprintf(fileId, ' & & Final Rank (Final Rank UB) & %d (%d) & & %d (%d) & %d (%d) & %d (%d) & %d (%d) & %d (%d) & & %d (%d) & %d (%d) & & %d (%d) \\\\ \n', round(rank_mat));
fprintf(fileId, ' & & Final Rank/Final Upper Bound & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(9,:));
fprintf(fileId, ' & & Percent Time Computing IF Directions & %8.2f\\%% & & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & & %8.2f\\%% & %8.2f\\%% & & %8.2f\\%% \\\\ \n', 100*CSV_mat(11,:));
fprintf(fileId, ' & & Percent Time Computing Regular Directions & %8.2f\\%% & & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & %8.2f\\%% & & %8.2f\\%% & %8.2f\\%% & & %8.2f\\%% \\\\ \n', 100*CSV_mat(12,:));
fprintf(fileId, ' & & Avg. IF Computation Time/Avg. Regular Computation Time & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(10,:));
fprintf(fileId, ' & & Avg. Regular Computation Time/Avg. IF Computation Time & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \\\\ \n', 1./CSV_mat(10,:));



fclose(fileId);