function val = sc_is_significant_diff(x, y, varargin)

s = sc_parse_input(varargin, 'significance_level', .05);
significance_level = sc_separate_input(s);


%[~, px_jb] = jbtest(x);
%[~, py_jb] = jbtest(y);

%[~, px_lt] = lillietest(x);
%[~, py_lt] = lillietest(y);

%if px_jb > significance_level && py_jb > significance_level
%  [~, p_tt_equal] = ttest2(x, y);
%  [~, p_tt_unequal] = ttest2(x, y, 'VarType', 'unequal');
%  p_kw = kruskalwallis([x y]);
%else
  p_rs = ranksum(x, y);
%end
%[px_jb py_jb]
%[p_tt_equal p_tt_unequal p_rs p_kw]

val = p_rs < significance_level;


end