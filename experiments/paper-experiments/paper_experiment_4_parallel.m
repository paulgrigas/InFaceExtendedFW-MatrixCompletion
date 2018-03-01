%rng(231);
%rng(786);

%num_trials = 1;

table_instances = cell(num_trials, 1);

% problem params
% m_size = 1500;
% n_size = 2000;
% true_rank = 15;
% percent_obs = 0.05;
% SNR = 2;

parfor n = 1:num_trials
    table_instances{n} = generate_table_instance(m_size, n_size, true_rank, percent_obs, SNR);
end