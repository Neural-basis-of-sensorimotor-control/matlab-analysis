function val = sc_is_normally_distributed(x, varargin)

s = sc_parse_input(varargin, 'significance_level', .05);
significance_level = sc_separate_input(s);

[~, p] = jbtest(x);

val = p < significance_level;

end