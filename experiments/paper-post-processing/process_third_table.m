function [total_iters, total_time, total_regular, total_interior_away, total_boundary_partial, total_boundary_full, final_rank, rank_ub, rank_raio, work_ratio, time_percent_IF, time_percent_regular] = process_third_table(history, final_tol, best_lwbnd)
    
    rel_gaps = (history.objvals(1:history.num_iters) - best_lwbnd*ones(history.num_iters, 1))/best_lwbnd;
    effective_num_iters = find(rel_gaps < final_tol, 1);
    if isempty(effective_num_iters)
        effective_num_iters = history.num_iters;
    end
    total_iters = effective_num_iters;
    
    iter_types = history.itertypes(1:effective_num_iters);
    ranks = history.ranks(1:effective_num_iters);
    
    if isfield(history, 'numatoms')
        numatoms = history.numatoms;
    end
    
    total_regular = 0;
    total_interior_away = 0;
    total_boundary_partial = 0;
    total_boundary_full = 0;
    for i = 1:effective_num_iters
        cur_it = iter_types{i};
        if strcmp(cur_it, 'regular')
            total_regular = total_regular + 1;
        elseif strcmp(cur_it, 'away')
            % GM decision rule
            % we must be at i >= 2
            if isfield(history, 'numatoms')
                % atomic version of GM
                if numatoms(i) > numatoms(i-1)
                    error('Number of atoms increased in an away step?');
                elseif numatoms(i) < numatoms(i-1)
                    total_boundary_full = total_boundary_full + 1;
                else
                    total_boundary_partial = total_boundary_partial + 1;
                end
            else
                % non-atmoic version
                if ranks(i) > ranks(i - 1)
                    total_interior_away = total_interior_away + 1;
                elseif ranks(i) < ranks(i - 1)
                    total_boundary_full = total_boundary_full + 1;
                else
                    total_boundary_partial = total_boundary_partial + 1;
                end  
            end         
        elseif strcmp(cur_it, 'away_full')
            % Algorithm 3
            % we must be at i >= 2
            if ranks(i) > ranks(i - 1)
                total_interior_away = total_interior_away + 1;
            elseif ranks(i) < ranks(i - 1)
                total_boundary_full = total_boundary_full + 1;
            else
                total_boundary_partial = total_boundary_partial + 1;
            end              
        elseif strcmp(cur_it, 'away_partial')
            % Algorithm 3
            % we must be at i >= 2
            if ranks(i) > ranks(i - 1)
                total_interior_away = total_interior_away + 1;
            elseif ranks(i) < ranks(i - 1)
                total_boundary_full = total_boundary_full + 1;
            else
                total_boundary_partial = total_boundary_partial + 1;
            end  
        elseif strcmp(cur_it, 'in-face')    
            % in-face opt
            % we must be at i >= 2
            if isfield(history, 'numatoms')
                % fully corrective
                if numatoms(i) > numatoms(i-1)
                    error('Number of atoms increased in an away step?');
                elseif numatoms(i) < numatoms(i-1)
                    total_boundary_full = total_boundary_full + 1;
                else
                    total_boundary_partial = total_boundary_partial + 1;
                end
            else
                % non-atmoic version
                if ranks(i) > ranks(i - 1)
                    total_interior_away = total_interior_away + 1;
                elseif ranks(i) < ranks(i - 1)
                    total_boundary_full = total_boundary_full + 1;
                else
                    total_boundary_partial = total_boundary_partial + 1;
                end  
            end
        else
            error('Not a valid itertype');
        end    
    end
    
    % get rank ratio
    rank_ub = effective_num_iters - 2*total_boundary_full - total_boundary_partial;
    if isfield(history, 'final_true_rank')
        final_rank = history.final_true_rank;
    else
        final_rank = ranks(effective_num_iters);
    end
    rank_raio = final_rank/rank_ub;
    
    
    % get work ratio and percentage of time
    total_time = history.cputimes(effective_num_iters);
    total_alt_time = history.alt_cputimes(effective_num_iters);
    total_regular_time = history.regular_cputimes(effective_num_iters);
    time_percent_IF = total_alt_time/total_time;
    time_percent_regular = total_regular_time/total_time;
    
    alt_times = history.alt_cputimes(1:effective_num_iters);
    regular_times = history.regular_cputimes(1:effective_num_iters);
    
    num_alt_calls = get_num_jumps(alt_times);
    num_regular_calls = get_num_jumps(regular_times);
    
    average_alt_time = total_alt_time/num_alt_calls;
    average_regular_time = total_regular_time/num_regular_calls;
    
    work_ratio = average_alt_time/average_regular_time;
    
end