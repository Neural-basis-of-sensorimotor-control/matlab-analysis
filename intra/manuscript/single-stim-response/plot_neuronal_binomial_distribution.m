function plot_neuronal_binomial_distribution(binomial_permutations, ...
  nbr_of_positives, title_str, legend_str, varargin)

xtick = nan(size(nbr_of_positives));
xticklabel = cell(size(xtick));
unique_xtick = unique(nbr_of_positives);

for j=1:length(unique_xtick)
  indx = find(nbr_of_positives == unique_xtick(j));
  
  dx = .9/length(indx)*( 0:(length(indx)-1))';
  dx = dx - mean(dx);
  
  xtick(indx) = unique_xtick(j) + dx;
  
  for k=1:length(indx)
    xticklabel(indx(k)) = {num2str(binomial_permutations(indx(k),:))};
  end
end

bar(xtick, cell2mat(varargin));

set(gca, 'XTick', xtick, 'XTickLabel',xticklabel,'XTickLabelRotation', 270)
title(title_str);
legend(legend_str);

end