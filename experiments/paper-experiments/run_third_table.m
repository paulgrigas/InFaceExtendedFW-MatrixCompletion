for i = 1:3
    clearvars -except i;
    load_string = sprintf('ex%d_small.mat', i);
    load(load_string);
    
    options = struct();
    options.rel_opt_TOL = 10^-2.5;
    options.time_limit = 400;
    
    new_table_instances = cell(25,1);
    parfor j = 1:25
        new_table_instances{j} = run_algs_table(table_instances{j}, options);
    end
    
    save_string = sprintf('ex%d_small_updated_july_third_table.mat', i);
    save(save_string);
end

