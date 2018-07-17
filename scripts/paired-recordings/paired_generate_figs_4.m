clc
close all
clear

sc_settings.set_current_settings_tag(sc_settings.tags.DEFAULT);
sc_debug.set_mode(true);

neurons = paired_get_extra_neurons();
params_ci = nan(6, 2, 2*length(neurons));
depth     = nan(2*length(neurons), 1);
tags = cell(2*length(neurons), 1);
for i=1:length(neurons)
  sc_debug.print(i, length(neurons));
  indx1 = i*2-1;
  indx2 = indx1+1;
  [params_ci(:, :, indx1), depth(indx1), tags(indx1)] = paired_bootstrap_params(neurons(i), false);
  [params_ci(:, :, indx2), depth(indx2), tags(indx2)] = paired_bootstrap_params(neurons(i), true);
end

unique_tags = unique(tags);
for i=1:length(unique_tags)
  indx = find(strcmp(tags, unique_tags{i}));
  for j=1:length(indx)
    tags(indx(j)) = {sprintf('%s (%d)', tags{indx(j)}, j)};
  end
end

incr_fig_indx()
clf
for i=1:length(tags)
  for j=1:6
    subplot(2,3,j)
    hold on
    plot([params_ci(j, :, i) mean(params_ci(j, :, i))], -depth(i)*[1 1 1], 'Marker', '+', 'LineStyle', '-', 'MarkerSize', 6, 'Tag', tags{i})
  end
end
add_legend(gcf, true);
