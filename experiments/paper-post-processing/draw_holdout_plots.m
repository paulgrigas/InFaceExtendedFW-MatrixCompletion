function draw_holdout_plots(historyFW, train_baseline, test_baseline, full_baseline)
    figure
    plot(historyFW.deltas_norepeats, historyFW.minranks, 'r');
    title('Rank vs. Delta')
    
    figure
    plot(historyFW.deltas_norepeats, historyFW.objvals./train_baseline, 'r', historyFW.deltas_norepeats, historyFW.test_vals./test_baseline, 'b', historyFW.deltas_norepeats, historyFW.full_objvals./full_baseline, 'k');
    title('Training/Testing Error vs. Delta')
end