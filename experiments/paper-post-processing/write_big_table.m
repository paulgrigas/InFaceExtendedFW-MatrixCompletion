fileId = fopen('big_table.txt', 'w');

load('ex1_big.mat');
CSV_mat = return_csv_mat(table_instances, 1);
rank_mat = CSV_mat(2:3, :); rank_mat = rank_mat(:);

delta = table_instances{1}.delta_found;
fprintf(fileId, '$ m = %d, n = %d, \\rho = %8.2f $ & & CPU Time (secs) & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f \\\\ \n', m_size, n_size, percent_obs, CSV_mat(1,:));
fprintf(fileId, '$ r = %d, \\text{SNR} = %d, \\delta = %8.2f $ & & Final Rank (Max Rank) & %d (%d) & & %d (%d) & %d (%d) & %d (%d) & %d (%d) & %d (%d) & & %d (%d) & %d (%d) \\\\ \\\\ \n', true_rank, SNR, delta, rank_mat);


clear;
fileId = fopen('big_table.txt', 'a');
load('ex2_big.mat');
CSV_mat = return_csv_mat(table_instances, 1);
rank_mat = CSV_mat(2:3, :); rank_mat = rank_mat(:);

delta = table_instances{1}.delta_found;
fprintf(fileId, '$ m = %d, n = %d, \\rho = %8.2f $ & & CPU Time (secs) & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f \\\\ \n', m_size, n_size, percent_obs, CSV_mat(1,:));
fprintf(fileId, '$ r = %d, \\text{SNR} = %d, \\delta = %8.2f $ & & Final Rank (Max Rank) & %d (%d) & & %d (%d) & %d (%d) & %d (%d) & %d (%d) & %d (%d) & & %d (%d) & %d (%d) \\\\ \\\\ \n', true_rank, SNR, delta, rank_mat);


clear;
fileId = fopen('big_table.txt', 'a');
load('ex3_big.mat');
CSV_mat = return_csv_mat(table_instances, 1);
rank_mat = CSV_mat(2:3, :); rank_mat = rank_mat(:);

delta = table_instances{1}.delta_found;
fprintf(fileId, '$ m = %d, n = %d, \\rho = %8.2f $ & & CPU Time (secs) & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f \\\\ \n', m_size, n_size, percent_obs, CSV_mat(1,:));
fprintf(fileId, '$ r = %d, \\text{SNR} = %d, \\delta = %8.2f $ & & Final Rank (Max Rank) & %d (%d) & & %d (%d) & %d (%d) & %d (%d) & %d (%d) & %d (%d) & & %d (%d) & %d (%d) \\\\ \\\\ \n', true_rank, SNR, delta, rank_mat);


clear;
fileId = fopen('big_table.txt', 'a');
load('ex4_big.mat');
CSV_mat = return_csv_mat(table_instances, 1);
rank_mat = CSV_mat(2:3, :); rank_mat = rank_mat(:);

delta = table_instances{1}.delta_found;
fprintf(fileId, '$ m = %d, n = %d, \\rho = %8.2f $ & & CPU Time (secs) & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f \\\\ \n', m_size, n_size, percent_obs, CSV_mat(1,:));
fprintf(fileId, '$ r = %d, \\text{SNR} = %d, \\delta = %8.2f $ & & Final Rank (Max Rank) & %d (%d) & & %d (%d) & %d (%d) & %d (%d) & %d (%d) & %d (%d) & & %d (%d) & %d (%d) \\\\ \\\\ \n', true_rank, SNR, delta, rank_mat);


clear;
fileId = fopen('big_table.txt', 'a');
load('ex5_big.mat');
CSV_mat = return_csv_mat(table_instances, 1);
rank_mat = CSV_mat(2:3, :); rank_mat = rank_mat(:);

delta = table_instances{1}.delta_found;
fprintf(fileId, '$ m = %d, n = %d, \\rho = %8.2f $ & & CPU Time (secs) & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f \\\\ \n', m_size, n_size, percent_obs, CSV_mat(1,:));
fprintf(fileId, '$ r = %d, \\text{SNR} = %d, \\delta = %8.2f $ & & Final Rank (Max Rank) & %d (%d) & & %d (%d) & %d (%d) & %d (%d) & %d (%d) & %d (%d) & & %d (%d) & %d (%d) \\\\ \\\\ \n', true_rank, SNR, delta, rank_mat);


clear;
fileId = fopen('big_table.txt', 'a');
load('ex6_big.mat');
CSV_mat = return_csv_mat(table_instances, 1);
rank_mat = CSV_mat(2:3, :); rank_mat = rank_mat(:);

delta = table_instances{1}.delta_found;
fprintf(fileId, '$ m = %d, n = %d, \\rho = %8.2f $ & & CPU Time (secs) & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f \\\\ \n', m_size, n_size, percent_obs, CSV_mat(1,:));
fprintf(fileId, '$ r = %d, \\text{SNR} = %d, \\delta = %8.2f $ & & Final Rank (Max Rank) & %d (%d) & & %d (%d) & %d (%d) & %d (%d) & %d (%d) & %d (%d) & & %d (%d) & %d (%d) \\\\ \\\\ \n', true_rank, SNR, delta, rank_mat);


clear;
fileId = fopen('big_table.txt', 'a');
load('ex7_big.mat');
CSV_mat = return_csv_mat(table_instances, 1);
rank_mat = CSV_mat(2:3, :); rank_mat = rank_mat(:);

delta = table_instances{1}.delta_found;
fprintf(fileId, '$ m = %d, n = %d, \\rho = %8.2f $ & & CPU Time (secs) & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f \\\\ \n', m_size, n_size, percent_obs, CSV_mat(1,:));
fprintf(fileId, '$ r = %d, \\text{SNR} = %d, \\delta = %8.2f $ & & Final Rank (Max Rank) & %d (%d) & & %d (%d) & %d (%d) & %d (%d) & %d (%d) & %d (%d) & & %d (%d) & %d (%d) \\\\ \\\\ \n', true_rank, SNR, delta, rank_mat);


clear;
fileId = fopen('big_table.txt', 'a');
load('ex8_big.mat');
CSV_mat = return_csv_mat(table_instances, 1);
rank_mat = CSV_mat(2:3, :); rank_mat = rank_mat(:);

delta = table_instances{1}.delta_found;
fprintf(fileId, '$ m = %d, n = %d, \\rho = %8.2f $ & & CPU Time (secs) & %8.2f & & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & & %8.2f & %8.2f \\\\ \n', m_size, n_size, percent_obs, CSV_mat(1,:));
fprintf(fileId, '$ r = %d, \\text{SNR} = %d, \\delta = %8.2f $ & & Final Rank (Max Rank) & %d (%d) & & %d (%d) & %d (%d) & %d (%d) & %d (%d) & %d (%d) & & %d (%d) & %d (%d) \\\\ \\\\ \n', true_rank, SNR, delta, rank_mat);

fclose(fileId);