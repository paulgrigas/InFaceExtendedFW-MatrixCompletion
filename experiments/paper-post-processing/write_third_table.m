fileId = fopen('third_table.txt', 'w');
fprintf(fileId, ' & & & & & & & & & & \\\\ \n ');

load('ex1_small_updated_july_third_table.mat');
CSV_mat = return_csv_mat_third(new_table_instances, num_trials);

delta_sum = 0;
for i = 1:num_trials
    delta_sum = delta_sum + table_instances{i}.delta_found;
end
delta = delta_sum/num_trials;

fprintf(fileId, '$ m = %d, n = %d, \\rho = %8.2f $ & & Total CPU Time & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', m_size, n_size, percent_obs, CSV_mat(2,:));
fprintf(fileId, '$ r = %d, \\text{SNR} = %d, \\delta_{\\text{avg}} = %8.2f $ & & Total Iters & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', true_rank, SNR, delta, CSV_mat(1,:));
fprintf(fileId, ' & & Total Regular Steps & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(3,:));
fprintf(fileId, ' & & Total Partial IF Steps & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(4,:));
fprintf(fileId, ' & & Total Full IF Steps & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(5,:));
fprintf(fileId, ' & & Percent Time Computing IF Directions & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(7,:));
fprintf(fileId, ' & & Percent Time Computing Regular Directions & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(8,:));
fprintf(fileId, ' & & Avg. IF Computation Time/Avg. Regular Computation Time & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \\\\ \n', CSV_mat(6,:));




clear;
fileId = fopen('third_table.txt', 'a');
load('ex2_small_updated_july_third_table.mat');
CSV_mat = return_csv_mat_third(new_table_instances, num_trials);

delta_sum = 0;
for i = 1:num_trials
    delta_sum = delta_sum + table_instances{i}.delta_found;
end
delta = delta_sum/num_trials;

fprintf(fileId, '$ m = %d, n = %d, \\rho = %8.2f $ & & Total CPU Time & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', m_size, n_size, percent_obs, CSV_mat(2,:));
fprintf(fileId, '$ r = %d, \\text{SNR} = %d, \\delta_{\\text{avg}} = %8.2f $ & & Total Iters & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', true_rank, SNR, delta, CSV_mat(1,:));
fprintf(fileId, ' & & Total Regular Steps & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(3,:));
fprintf(fileId, ' & & Total Partial IF Steps & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(4,:));
fprintf(fileId, ' & & Total Full IF Steps & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(5,:));
fprintf(fileId, ' & & Percent Time Computing IF Directions & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(7,:));
fprintf(fileId, ' & & Percent Time Computing Regular Directions & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(8,:));
fprintf(fileId, ' & & Avg. IF Computation Time/Avg. Regular Computation Time & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \\\\ \n', CSV_mat(6,:));



clear;
fileId = fopen('third_table.txt', 'a');
load('ex3_small_updated_july_third_table.mat');
CSV_mat = return_csv_mat_third(new_table_instances, num_trials);

delta_sum = 0;
for i = 1:num_trials
    delta_sum = delta_sum + table_instances{i}.delta_found;
end
delta = delta_sum/num_trials;

fprintf(fileId, '$ m = %d, n = %d, \\rho = %8.2f $ & & Total CPU Time & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', m_size, n_size, percent_obs, CSV_mat(2,:));
fprintf(fileId, '$ r = %d, \\text{SNR} = %d, \\delta_{\\text{avg}} = %8.2f $ & & Total Iters & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', true_rank, SNR, delta, CSV_mat(1,:));
fprintf(fileId, ' & & Total Regular Steps & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(3,:));
fprintf(fileId, ' & & Total Partial IF Steps & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(4,:));
fprintf(fileId, ' & & Total Full IF Steps & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(5,:));
fprintf(fileId, ' & & Percent Time Computing IF Directions & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(7,:));
fprintf(fileId, ' & & Percent Time Computing Regular Directions & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(8,:));
fprintf(fileId, ' & & Avg. IF Computation Time/Avg. Regular Computation Time & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f & & %8.2f \\\\ \n', CSV_mat(6,:));



fclose(fileId);