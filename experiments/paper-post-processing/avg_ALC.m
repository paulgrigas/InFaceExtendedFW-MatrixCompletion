function avg_alc = avg_ALC(rel_gaps, history)
    log_rel = log10(rel_gaps);
    
    ind = (log_rel < 0) & (log_rel > -3);
    
    x_axis = -[0; log_rel(ind); -3];
    
    y_axis = history.cputimes(ind);
    y_axis = [interp1q(-log_rel,history.cputimes,0); y_axis; interp1q(-log_rel,history.cputimes,3)];
    avg_alc = trapz(x_axis, y_axis);
    
    %plot(x_axis, y_axis);
end