function val = incr_fig_indx

global fig_indx

if isempty(fig_indx) || fig_indx < 1
  fig_indx = 1;
else
  fig_indx = fig_indx + 1;
end

val = figure(fig_indx);

clf(val, 'reset');

end