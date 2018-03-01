for i = 1:3
    clearvars -except i;
    load_string = sprintf('ex%d_small_updated_FCcogent_july2.mat', i);
    load(load_string);
    
    for j = 1:25
        table_instance = table_instances{j};
        his_FC = table_instance.history_fullopt_atom;
        if his_FC.prox_grad_not_monotone_flag == 1
            error('Prox gradient was not monotone at some point!');
        end
        
        his_CO_no_svt = table_instance.history_cogent_no_svt;
        if max(his_CO_no_svt.cputimes) > 500
            error('Cogent NO SVT messed up');
        end
        his_CO_svt = table_instance.history_cogent_svt;
        if max(his_CO_svt.cputimes) > 500
            fprintf('Cogent SVT messed up for i = %d, j = %d\n', i, j);
        end
    end
end
disp('Everyting worked!!');