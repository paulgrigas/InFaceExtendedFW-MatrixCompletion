function table_instance = generate_table_instance(m_size, n_size, true_rank, percent_obs, SNR, alg_options)

%%% Generate matrix completion problem
mat_comp_instance = generate_mat_comp_instance_table(m_size, n_size, true_rank, percent_obs, SNR);

%%%% Begin path algorithm to select delta %%%%%
table_instance = select_delta_table(mat_comp_instance);

%%% Run algorithms %%%
table_instance = run_algs_table(table_instance, alg_options);

end