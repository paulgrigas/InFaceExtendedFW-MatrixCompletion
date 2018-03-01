addpath('../solver');

rng(81911);
num_trials = 1;
m_size = 2000;
n_size = 2500;
true_rank = 10;
percent_obs = 0.01;
SNR = 4;

generate_table_instances_parallel;