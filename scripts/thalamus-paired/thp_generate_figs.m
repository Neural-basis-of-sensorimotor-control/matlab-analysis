reset_fig_indx()
close all
sc_settings.set_current_settings_tag(sc_settings.tags.HANNES)
paired_load_settings();
thp_load_constants();

stress = paired_mds(ec_neurons);

params_ci = nan(6, 2, 2*length(ec_neurons));
depth     = nan(2*length(ec_neurons), 1);
tags = cell(2*length(ec_neurons), 1);
for i=1:length(ec_neurons)
  sc_debug.print(i, length(ec_neurons));
  indx1 = i*2-1;
  indx2 = indx1+1;
  [params_ci(:, :, indx1), depth(indx1), tags(indx1)] = paired_bootstrap_params(ec_neurons(i), false);
  [params_ci(:, :, indx2), depth(indx2), tags(indx2)] = paired_bootstrap_params(ec_neurons(i), true);
end

unique_tags = unique(tags);
for i=1:length(unique_tags)
  indx = find(strcmp(tags, unique_tags{i}));
  for j=1:length(indx)
    tags(indx(j)) = {sprintf('%s (%d)', tags{indx(j)}, j)};
  end
end

msgs = cell(2*length(ec_neurons), 1);
for i=1:length(ec_neurons)
  msg = paired_get_cell_msg(ec_neurons(i));
  msgs(2*i-1) = {msg};
  msgs(2*i)   = {msg};
end

incr_fig_indx()
clf
for i=1:length(tags)
  for j=1:6
    subplot(2,3,j)
    hold on
    x_mean =  mean(params_ci(j, :, i));
    y      = -depth(i);
    plot([params_ci(j, :, i) x_mean], -y*[1 1 1], 'Marker', '+', 'LineStyle', '-', 'MarkerSize', 6, 'Tag', tags{i})
    if ~isempty(msgs{i})
      text(x, y, msgs{i});
    end
  end
end
add_legend(gcf, true);

ec_neurons = paired_rm_nonresponsive(ec_neurons, 10*ec_kernelwidth, ...
  ec_pretrigger);
