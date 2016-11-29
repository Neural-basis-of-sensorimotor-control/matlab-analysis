function add_colormaps(plothandle, varargin)
% add_colormaps(z, [-inf 0], 'bone', [0 1], 'gray', [1 inf], 'hello']

z = get(plothandle, 'ZData');

m = round(128 / length(varargin)/2);

c = zeros(size(z));
c = nan(128, 3);
last_max = 0;
last_cmap_indx = 0;

for i=1:2:length(varargin)
  limits = varargin{i};
  cmap = varargin{i+1};
  
  if i+2<length(varargin)
    nbr_of_cmap_entries = m;
  else
    nbr_of_cmap_entries = size(cmaps, 1) - last_cmap_indx;
  end
  
  cmap_indx = last_cmap_indx + (1:nbr_of_cmap_entries);
  last_cmap_indx = last_cmap_indx + nbr_of_cmap_entries;
  cmaps(cmap_indx) =  cmap(nbr_of_cmap_entries);
  
  lower_limit = limits(1);
  upper_limit = limits(2);
  
  ind = z >= lower_limit & z < upper_limit;
  
  if isinf(lower_limit)
    cmin = min(z(ind));
  else
    cmin = lower_limit;
  end
  
  if isinf(upper_limit)
    cmax = max(z(ind));
  else
    cmax = upper_limit;
  end
  
  c(ind) = c(ind) + last_max + ...
    min(m, round((m-1)*(z(ind) - cmin) / (cmax - cmin)) + 1);
  
  last_max = cmax;
end

set(plothandle, 'CData', c);
caxis(plothandle, [min(c(:)) max(c(:))]);
colorbar