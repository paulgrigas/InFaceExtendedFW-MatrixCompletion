function CSV_mat = return_csv_mat(table_instances, num_trials)
avg_alcs_25 = zeros(10, num_trials);
total_times_25 = zeros(10, num_trials);
final_ranks_25 = zeros(10, num_trials);
max_ranks_25 = zeros(10, num_trials);

for i = 1:num_trials
    [avg_alcs, total_times, final_ranks, max_ranks] = process_table_instance(table_instances{i}, 10^-2.5, 1);
    avg_alcs_25(:, i) = avg_alcs;
    total_times_25(:, i) = total_times;
    final_ranks_25(:, i) = final_ranks;
    max_ranks_25(:, i) = max_ranks;
end
avg_alcs = mean(avg_alcs_25, 2);
total_times = mean(total_times_25, 2);
final_ranks = mean(final_ranks_25, 2);
max_ranks = mean(max_ranks_25, 2);
CSV_mat = [avg_alcs'; total_times'; final_ranks'; max_ranks'];
CSV_mat = [CSV_mat(2:4, 1:4), CSV_mat(2:4, 6:10)];
CSV_mat2 = CSV_mat; CSV_mat2(:,5) = CSV_mat(:,6); CSV_mat2(:,6) = CSV_mat(:,5); CSV_mat = CSV_mat2;
CSV_mat = [CSV_mat(:, 1:4), CSV_mat(:, 6:9)];
CSV_mat2 = CSV_mat; CSV_mat2(:,5) = CSV_mat(:,6); CSV_mat2(:,6) = CSV_mat(:,5); CSV_mat = CSV_mat2;

end