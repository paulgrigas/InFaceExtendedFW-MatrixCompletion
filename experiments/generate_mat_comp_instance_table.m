function mat_comp_instance = generate_mat_comp_instance_table(m_size, n_size, true_rank, percent_obs, SNR)
gen_opts = struct();
gen_opts.return_zstar = 1;
gen_opts.normalize = 1;
[no_obs, Omega, irow, jcol, Xobs_vec, Z_star] = FUN_generate_example(m_size, n_size, true_rank, percent_obs, SNR, gen_opts);

mat_comp_instance = struct();
mat_comp_instance.X_obs_vec = Xobs_vec;
mat_comp_instance.irow = irow;
mat_comp_instance.jcol = jcol;
mat_comp_instance.Z_star = Z_star;

mat_comp_instance.delta_min = 0;
mat_comp_instance.dual_norm_bound = norm(Xobs_vec, 2);
mat_comp_instance.delta_max = sqrt(min(m_size, n_size))*mat_comp_instance.dual_norm_bound;

end