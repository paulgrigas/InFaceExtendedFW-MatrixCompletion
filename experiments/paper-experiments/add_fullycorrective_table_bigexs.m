for i = 1:9
    clearvars -except i;
    
    if i == 9
        load_string = 'ex_plots.mat';
    else
        load_string = sprintf('ex%d_big.mat', i);
    end
    
    load(load_string);
    table_instance = table_instances{1};
    table_instance = add_fullycorrective_table(table_instance, alg_options);
    
    if i == 9
        save_string = 'ex_plots_updated_FC_july2.mat';
    else
        save_string = sprintf('ex%d_big_updated_FC_july2.mat', i);
    end
    
    save(save_string);
end