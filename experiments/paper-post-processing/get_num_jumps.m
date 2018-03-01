function num_jumps = get_num_jumps(vec)
    n = length(vec);
    
    num_jumps = 0;
    for i = 2:n
        if vec(i) > vec(i-1)
            num_jumps = num_jumps + 1;
        end
    end
end