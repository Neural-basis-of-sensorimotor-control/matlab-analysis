function sc_clf_all(varargin)
% SC_CLF_ALL Clear all open figures

f = get_all_figures();%findall(0, 'Type', 'figure');
for i=1:length(f)
  clf(f(i), varargin{:})
end
