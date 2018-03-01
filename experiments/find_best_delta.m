function delta = find_best_delta(historyFWpath, stdev_left, tol, full)

if full == 1
    test_errs = historyFWpath.full_objvals;
else
    test_errs = historyFWpath.test_vals_smart;
end

min_errs = min(test_errs);
std_errs = std(test_errs);

ind = find(test_errs < min_errs + stdev_left*std_errs + tol, 1);
delta = historyFWpath.deltas_norepeats(ind);

end