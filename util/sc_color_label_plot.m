function sc_color_label_plot(plots)

tags = {plots.Tag};
unique_tags = unique(tags);

colors = varycolor(length(unique_tags));

for i=1:length(plots)
  plots(i).Color = colors(sc_str_find(unique_tags, plots(i).Tag), :);
end

end