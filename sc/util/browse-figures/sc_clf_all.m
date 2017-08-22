function sc_clf_all(varargin)
% SC_CLF_ALL Clear all open figures

f = get_all_figures();

for i=1:length(f)
  
  if ~strcmp(get(f(i), 'Tag'), SequenceViewer.figure_tag)
    
    clf(f(i), varargin{:})
  
  end
  
end
