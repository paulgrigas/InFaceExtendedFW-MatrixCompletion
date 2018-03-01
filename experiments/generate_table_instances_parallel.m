table_instances = cell(num_trials, 1);

if num_trials == 1
    table_instances{1} = generate_table_instance(m_size, n_size, true_rank, percent_obs, SNR);
else
    parfor n = 1:num_trials
        table_instances{n} = generate_table_instance(m_size, n_size, true_rank, percent_obs, SNR);
    end    
end