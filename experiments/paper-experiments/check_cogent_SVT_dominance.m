for i = 1:3
    clearvars -except i;
    load_string = sprintf('ex%d_small_updated_FCcogent_july2.mat', i);
    load(load_string);
    
    for j = 1:25
        table_instance = table_instances{j};
        
        his_CO_no_svt = table_instance.history_cogent_no_svt;
        his_CO_svt = table_instance.history_cogent_svt;
        if max(his_CO_no_svt.cputimes) < max(his_CO_svt.cputimes)
            fprintf('No SVT was better: i is %d, j is %d\n', i, j);
        end
    end
end
disp('SVT was always better');