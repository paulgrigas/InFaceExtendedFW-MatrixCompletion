fileId = fopen('small_table.txt', 'w');
fprintf(fileId, ' & & & & & & & & & & \\\\ \n ');

load('ex1_small.mat');
CSV_mat = return_csv_mat(table_instances, num_trials);
rank_mat = CSV_mat(2:3, :); rank_mat = rank_mat(:);

delta_sum = 0;
for i = 1:num_trials
    delta_sum = delta_sum + table_instances{i}.delta_found;
end
delta = delta_sum/num_trials;

fprintf(fileId, '$ m = %d, n = %d, \\rho = %8.2f $ & & CPU Time (secs) & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f \\\\ \n', m_size, n_size, percent_obs, CSV_mat(1,:));
fprintf(fileId, '$ r = %d, \\text{SNR} = %d, \\delta_{\\text{avg}} = %8.2f $ & & Final Rank & %0.2f & & %0.2f & %0.2f & %0.2f & %0.2f & %0.2f & & %0.2f & %0.2f \\\\ \n', true_rank, SNR, delta, CSV_mat(2,:));
fprintf(fileId, ' & & Maximum Rank & %0.2f & & %0.2f & %0.2f & %0.2f & %0.2f & %0.2f & & %0.2f & %0.2f \\\\ \\\\ \n', CSV_mat(3,:));

clear;
fileId = fopen('small_table.txt', 'a');
load('ex2_small.mat');
CSV_mat = return_csv_mat(table_instances, num_trials);
rank_mat = CSV_mat(2:3, :); rank_mat = rank_mat(:);

delta_sum = 0;
for i = 1:num_trials
    delta_sum = delta_sum + table_instances{i}.delta_found;
end
delta = delta_sum/num_trials;

fprintf(fileId, '$ m = %d, n = %d, \\rho = %8.2f $ & & CPU Time (secs) & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f \\\\ \n', m_size, n_size, percent_obs, CSV_mat(1,:));
fprintf(fileId, '$ r = %d, \\text{SNR} = %d, \\delta_{\\text{avg}} = %8.2f $ & & Final Rank & %0.2f & & %0.2f & %0.2f & %0.2f & %0.2f & %0.2f & & %0.2f & %0.2f \\\\ \n', true_rank, SNR, delta, CSV_mat(2,:));
fprintf(fileId, ' & & Maximum Rank & %0.2f & & %0.2f & %0.2f & %0.2f & %0.2f & %0.2f & & %0.2f & %0.2f \\\\ \\\\ \n', CSV_mat(3,:));



clear;
fileId = fopen('small_table.txt', 'a');
load('ex3_small.mat');
CSV_mat = return_csv_mat(table_instances, num_trials);
rank_mat = CSV_mat(2:3, :); rank_mat = rank_mat(:);

delta_sum = 0;
for i = 1:num_trials
    delta_sum = delta_sum + table_instances{i}.delta_found;
end
delta = delta_sum/num_trials;

fprintf(fileId, '$ m = %d, n = %d, \\rho = %8.2f $ & & CPU Time (secs) & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f \\\\ \n', m_size, n_size, percent_obs, CSV_mat(1,:));
fprintf(fileId, '$ r = %d, \\text{SNR} = %d, \\delta_{\\text{avg}} = %8.2f $ & & Final Rank & %0.2f & & %0.2f & %0.2f & %0.2f & %0.2f & %0.2f & & %0.2f & %0.2f \\\\ \n', true_rank, SNR, delta, CSV_mat(2,:));
fprintf(fileId, ' & & Maximum Rank & %0.2f & & %0.2f & %0.2f & %0.2f & %0.2f & %0.2f & & %0.2f & %0.2f \\\\ \\\\ \n', CSV_mat(3,:));



fclose(fileId);