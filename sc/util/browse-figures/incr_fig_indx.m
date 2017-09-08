function val = incr_fig_indx(increment)

global FIG_INDX

if ~nargin
  increment = 1;
end

if isempty(FIG_INDX) || FIG_INDX < 1
  FIG_INDX = 1;
else
  FIG_INDX = FIG_INDX + increment;
end

fig = figure(FIG_INDX);

while strcmp(get(fig, 'Tag'), SequenceViewer.figure_tag)
  fig = incr_fig_indx(increment);
end

if nargout
  val = fig;
end

end