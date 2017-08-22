function val = incr_fig_indx()

global FIG_INDX

if isempty(FIG_INDX) || FIG_INDX < 1
  FIG_INDX = 1;
else
  FIG_INDX = FIG_INDX + 1;
end

fig = figure(FIG_INDX);

while strcmp(get(fig, 'Tag'), SequenceViewer.figure_tag)
  fig = incr_fig_indx();
end

if nargout
  val = fig;
end

end