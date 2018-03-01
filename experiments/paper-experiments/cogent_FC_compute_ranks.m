rank_TOL = 10^-6;

for i = 1:3
    clearvars -except i rank_TOL;
    load_string = sprintf('ex%d_small_updated_FCcogent_july2.mat', i);
    load(load_string);
    
    FC_ranks = zeros(25,1);
    Cogent_ranks = zeros(25,1);
    FC_max_atoms = zeros(25,1);
    
    for j = 1:25
        t_inst = table_instances{j};
        
        final_FC = t_inst.final_soln_fullopt_atom;
        [U_FC, d_FC, V_FC] = svd(final_FC.U*diag(final_FC.d)*final_FC.V', 'econ');
        FC_ranks(j) = sum(diag(d_FC) > rank_TOL);
        FC_max_atoms(j) = max(t_inst.history_fullopt_atom.numatoms);
        
        final_cogent = t_inst.final_soln_cogent_svt;
        final_cogent = reshape(final_cogent, m_size, n_size);
        [U_C, d_C, V_C] = svd(final_cogent, 'econ');
        Cogent_ranks(j) = sum(diag(d_C) > rank_TOL);
    end
    
    fprintf(load_string);
    fprintf('\n');
    FC_avg_rank = mean(FC_ranks)
    FC_avg_max_atoms = mean(FC_max_atoms)
    Cogent_avg_rank = mean(Cogent_ranks)
end