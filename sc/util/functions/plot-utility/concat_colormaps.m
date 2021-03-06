function concat_colormaps(z, parent_axes, limits, varargin)

nbr_of_regions = length(limits) + 1;
cmaps = varargin;

if length(cmaps) < nbr_of_regions-1
  error('Mismatch between size of limits array and number of colormaps');
end

zmin = min(z(:));
zmax = max(z(:));

zrange = zmax - zmin;
n_colormap = 512;
cmapvalues = [];

for i=1:nbr_of_regions
  
  if i==1
    cmin = min(z(:));
  else
    cmin = cmax;
  end
  
  if i==nbr_of_regions
    cmax = max(z(:));
  else
    cmax = limits(i);
  end
  
  n_cmap = round((cmax-cmin)/zrange*n_colormap);
  
  if i<=length(cmaps)
    cmap = cmaps{i};
    tmp_cmapvalues = cmap(n_cmap);
  else
    tmp_cmapvalues = repmat(cmapvalues(end,:), n_cmap, 1);
  end
  
  cmapvalues = [cmapvalues; tmp_cmapvalues]; %#ok<AGROW>
end

colormap(parent_axes, cmapvalues);
colorbar(parent_axes);

end