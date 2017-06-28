function t = extract_within_sequence(t, sequence)

x1 = arrayfun(@(x) nnz(x >= sequence(:,1)), t);
x2 = arrayfun(@(x) nnz(x > sequence(:,2)), t);
t = t(x1 - x2 == 1);

end