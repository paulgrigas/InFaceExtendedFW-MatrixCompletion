rng(4521);

warning('error', 'MATLAB:eigs:NoEigsConverged');

%%% big table
num_trials = 1;
m_size = 500;
n_size = 1000;
true_rank = 15;
percent_obs = 0.25;
SNR = 2;

generate_table_instances_parallel;
save('ex1_big.mat');


clear;
num_trials = 1;
m_size = 500;
n_size = 1000;
true_rank = 15;
percent_obs = 0.25;
SNR = 10;

paper_experiment_4_parallel; % did not work twice
save('ex2_big.mat');


clear;
%rng(5203);
num_trials = 1;
m_size = 1500;
n_size = 2000;
true_rank = 15;
percent_obs = 0.05;
SNR = 2;

paper_experiment_4_parallel;
save('ex3_big.mat');

clear;
rng(3421); % because I ran this one first as a test
num_trials = 1;
m_size = 1500;
n_size = 2000;
true_rank = 15;
percent_obs = 0.05;
SNR = 10;

paper_experiment_4_parallel; % did not work twice, atomic is the problem
save('ex4_big_try2.mat');


clear;
rng(81911);
num_trials = 1;
m_size = 2000;
n_size = 2500;
true_rank = 10;
percent_obs = 0.01;
SNR = 4;

paper_experiment_4_parallel; % check this one carefully
save('ex5_big_plots.mat');


clear;
num_trials = 1;
m_size = 2000;
n_size = 2500;
true_rank = 10;
percent_obs = 0.05;
SNR = 2;

paper_experiment_4_parallel;
save('ex6_big.mat');


clear;
num_trials = 1;
m_size = 5000;
n_size = 5000;
true_rank = 10;
percent_obs = 0.01;
SNR = 4;

paper_experiment_4_parallel;
save('ex7_big.mat');


clear;
num_trials = 1;
m_size = 5000;
n_size = 7500;
true_rank = 10;
percent_obs = 0.005;
SNR = 4;

paper_experiment_4_parallel;
save('ex8_big.mat');


%%%% small table
clear;
num_trials = 25;
m_size = 200;
n_size = 400;
true_rank = 10;
percent_obs = 0.10;
SNR = 5;

paper_experiment_4_parallel;
save('ex1_small.mat');


rng(532);
clear;
num_trials = 25;
m_size = 200;
n_size = 400;
true_rank = 15;
percent_obs = 0.20;
SNR = 4;

paper_experiment_4_parallel;
save('ex2_small.mat');


rng(500);
clear;
num_trials = 25;
m_size = 200;
n_size = 400;
true_rank = 20;
percent_obs = 0.30;
SNR = 3;

paper_experiment_4_parallel;
save('ex3_small.mat');

clear;
movielens10M_run;