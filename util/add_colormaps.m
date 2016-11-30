function add_colormaps(plothandle, limits, varargin)
% add_colormaps(z, [-inf 0], 'bone', [0 1], 'gray', [1 inf], 'hello']

z = get(plothandle, 'ZData');
nbr_of_limits = length(limits) + 1;
m = round(128 / nbr_of_limits);

c = zeros(size(z));
cmap_values = nan(128,3);

last_cmap_indx = 0;

for i=1:nbr_of_limits
  
  if i == 1
    lower_limit = -inf;
    offset = 0;
  else
    lower_limit = limits(i-1);
    offset = lower_limit;
  end
  
  if i == nbr_of_limits
    upper_limit = inf;
    nbr_of_cmap_entries = size(cmap_values, 1) - last_cmap_indx;
  else
    upper_limit = limits(i);
    nbr_of_cmap_entries = m;
  end
  
  cmap = varargin{i};
  
  cmap_indx = last_cmap_indx + (1:nbr_of_cmap_entries);
  last_cmap_indx = last_cmap_indx + nbr_of_cmap_entries;
  cmap_values(cmap_indx, :) =  cmap(nbr_of_cmap_entries);
  
  z_ind = z >= lower_limit & z < upper_limit;
  
  if nnz(z_ind)
    if isinf(lower_limit)
      cmin = min(z(z_ind));
    else
      cmin = lower_limit;
    end
    
    if isinf(upper_limit)
      cmax = max(z(z_ind));
    else
      cmax = upper_limit;
    end
  
    c(z_ind) = c(z_ind) + offset + ...
      min(m, round((m-1)*(z(z_ind) - cmin) / (cmax - cmin)) + 1);
  end
end

set(plothandle, 'CData', c);
colormap(get(plothandle, 'Parent'), cmap_values);
caxis(get(plothandle, 'Parent'), [min(c(:)) max(c(:))]);
colorbar