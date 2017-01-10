function sc_export_to_jpg(fig)

if ~exist('fig', 'var')
  fig = sc_get_all_figs();
end

if length(fig) > 1
  for i=1:length(fig)
    sc_export_to_jpg(fig(i));
  end
else
  figure(fig)
  print('-dpdf', fig.Name);
end

end