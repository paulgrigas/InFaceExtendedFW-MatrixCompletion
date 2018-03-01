function [train_data, test_data] = split_matcomp_instance(Omega, irow, jcol, Xobs_vec, train_prop)
% split into training and testing data, where train_prop is the proportion to be training data

no_obs = length(Omega);

train_ind = rand(no_obs, 1) < train_prop;
test_ind = train_ind == 0;

% make sure training data contains at least one entry for each row/column
missing_rows = setdiff(irow(test_ind), irow(train_ind));
for k = 1:length(missing_rows)
    ind = find(irow == missing_rows(k), 1);
    train_ind(ind) = 1;
    test_ind(ind) = 0;
end
missing_cols = setdiff(jcol(test_ind), jcol(train_ind));
for k = 1:length(missing_cols)
    ind = find(jcol == missing_cols(k), 1);
    train_ind(ind) = 1;
    test_ind(ind) = 0;
end


train_data = struct();
train_data.Omega = Omega(train_ind);
train_data.irow = irow(train_ind);
train_data.jcol = jcol(train_ind);
train_data.Xobs_vec = Xobs_vec(train_ind);

test_data = struct();
test_data.Omega = Omega(test_ind);
test_data.irow = irow(test_ind);
test_data.jcol = jcol(test_ind);
test_data.Xobs_vec = Xobs_vec(test_ind);

end