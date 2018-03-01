for i = 1:3
    clearvars -except i;
    load_string = sprintf('ex%d_small.mat', i);
    load(load_string);
    
    parfor j = 1:25
        table_instances{j} = add_fullycorrective_table(table_instances{j});
        table_instances{j} = add_cogent_table(table_instances{j}); 
    end
    
    save_string = sprintf('ex%d_small_updated_FCcogent_july2.mat', i);
    save(save_string);
end