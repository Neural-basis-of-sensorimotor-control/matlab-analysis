function sc_clf_all()
% SC_CLF_ALL Close all open figures
f = findall(0, 'Type', 'figure');
for i=1:length(f)
  clf(f(i))
end
