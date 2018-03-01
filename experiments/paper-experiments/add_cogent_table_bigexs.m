for i = 1:9
    clearvars -except i;
    
    if i == 9
        load_string = 'ex_plots_updated_FC_july2.mat';
    else
        load_string = sprintf('ex%d_big_updated_FC_july2.mat', i);
    end
    
    load(load_string);
    new_table_instance = add_cogent_table(table_instance);
    
    if i == 9
        save_string = 'ex_plots_updated_cogent_july25.mat';
    else
        save_string = sprintf('ex%d_big_updated_cogent_july25.mat', i);
    end
    
    save(save_string);
end