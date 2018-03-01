rank_TOL = 10^-6;

for i = 1:3
    clearvars -except i rank_TOL;
    load_string = sprintf('ex%d_small_updated_july_third_table.mat', i);
    load(load_string);
    
    for j = 1:25        
        final_FC = new_table_instances{j}.final_soln_fullopt_atom;
        [U_FC, d_FC, V_FC] = svd(final_FC.U*diag(final_FC.d)*final_FC.V', 'econ');
        new_table_instances{j}.history_fullopt_atom.final_true_rank = sum(diag(d_FC) > rank_TOL);
    end
    
    save_string = sprintf('ex%d_small_updated_july_third_table_v2.mat', i);
    save(save_string);
end