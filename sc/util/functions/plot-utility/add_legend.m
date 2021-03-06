function legend_handle = add_legend(plot_handles, add_only_one_legend, ...
  invert_colors, varargin)

% ADD_LEGEND
% legend_handle = add_legend(plot_handles, add_only_one_legend, ...
%   invert_colors, varargin)
%
%   Add legend to plot axes, using the value of the Tag property for each
%   plot handle in the axes. Also adjust the LineColor property so that all
%   plots with the same Tag value have the same color.
%

if nargin<2
  add_only_one_legend = false;
end

if nargin<3
  invert_colors = false;
end

if ~nargin
  
  h = add_legend(gca, add_only_one_legend, invert_colors, varargin{:});
  
elseif isempty(plot_handles)
  
  h = [];
  
elseif any(arrayfun(@isfigure, plot_handles))
  
  h = add_legend(get_plots(plot_handles), add_only_one_legend, invert_colors, varargin{:});
  
elseif any(arrayfun(@isaxes, plot_handles))
  
  h = add_legend(get_plots(plot_handles), add_only_one_legend, invert_colors, varargin{:});
  
else
  
  tags = {plot_handles.Tag};
  unique_tags = unique(tags);
  
  colors = varycolor(length(unique_tags));
  
  if invert_colors
    colors = ones(size(colors)) - colors;
  end
  
  ax_handles = {plot_handles.Parent};
  unique_ax_handles = ax_handles{1};
  
  for i=2:length(ax_handles)
    if ~any(unique_ax_handles == ax_handles{i})
      unique_ax_handles = [unique_ax_handles; ax_handles{i}]; %#ok<AGROW>
    end
  end
  
  for i=1:length(plot_handles)
    indx = find(cellfun(@(x) strcmp(x, tags{i}), unique_tags), 1);
    set_plot_color(plot_handles(i), colors(indx, :));
  end
  
  empty_tag_indx = cellfun(@isempty, unique_tags);
  unique_tags(empty_tag_indx) = [];
  
  if ~isempty(unique_tags)
    
    sample_plots(length(unique_tags)) = plot_handles(end);
    
    for i=1:length(unique_tags)
      
      indx = find(cellfun(@(x) strcmp(x, unique_tags{i}), tags), 1);
      sample_plots(i) = plot_handles(indx);
      
    end
    
    if ~ischar(add_only_one_legend) && add_only_one_legend
      
      h = legend(unique_ax_handles(end), sample_plots, unique_tags{:});
      h.AutoUpdate = 'off';
      
      if ~isempty(varargin)
        set(h, varargin{:});
      end
   
    elseif ~ischar(add_only_one_legend)
      
      for i=1:length(unique_ax_handles)
        
        h(i) = legend(unique_ax_handles(i), sample_plots, unique_tags{:}); %#ok<AGROW>
        h(i).AutoUpdate = 'off';                                           %#ok<AGROW>
        
        if ~isempty(varargin)
          set(h(i), varargin{:});
        end
        
      end
      
    else
      
      h = [];
      
    end
    
  else
    
    h = [];
  
  end  
end

if nargout
  legend_handle = h;
end

end
