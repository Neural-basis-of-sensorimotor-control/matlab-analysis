function [v, v_median, filterwidth] = sc_remove_artifacts(v,filterwidth,stimpos)

if numel(stimpos) && filterwidth
  
  interspacing = [diff(stimpos)-1; numel(v)-stimpos(end)];
  interspacing = min(interspacing, numel(v)-stimpos);
  filterinput = bsxfun(@plus,stimpos,(1:filterwidth)-1);
  pos = filterinput - repmat(stimpos,1,filterwidth) <= repmat(interspacing,1,filterwidth);

  if any(~all(pos,1))
    
    fwidth = find(all(pos,1),1,'last');
    [v,v_median] = sc_remove_artifacts(v,fwidth,stimpos);
    zrs = numel(v_median)+1:filterwidth;
    v_median(zrs) = ones(size(zrs));
    filterwidth = fwidth;
    
  else
    
    v_median = nan(1,filterwidth);
    nbr_of_stims_per_filterwidth = sum(pos,1);
    min_filter_width = 1;
    
    for max_filter_width=unique(nbr_of_stims_per_filterwidth)
      
      columns = nbr_of_stims_per_filterwidth>=min_filter_width & nbr_of_stims_per_filterwidth <= max_filter_width;
      v_matrix = v(filterinput(min_filter_width:max_filter_width,columns));
      v_matrix = v_matrix - repmat(v_matrix(:,1),1,size(v_matrix,2));
      v_median(columns) = median(v_matrix,1);
      min_filter_width = max_filter_width+1;
    
    end
    
    if filterwidth == 1
      v(filterinput(pos)) = v(filterinput(pos)) - ones(size(filterinput(pos)))*v_median;
    else
      [~,medianpos] = find(pos);
      v(filterinput(pos)) = v(filterinput(pos)) - v_median(medianpos)';
    end
    
  end
  
else
  
  fprintf('Warning in %s: no filtering.\n',mfilename);
  v_median = [];
  
end

end
