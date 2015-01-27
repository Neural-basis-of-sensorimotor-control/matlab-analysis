function x = sc_remove_outliers(x)
pos = isfinite(x);
x = x(pos);
[~,ind] = max(x);
x(ind) = [];
[~,ind] = min(x);
x(ind) = [];
end