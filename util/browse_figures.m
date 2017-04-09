function browse_figures

figure_nbr = min(get_fig_nbrs());
fig = figure();

panel = uipanel('Parent', fig);

btn = uicontrol('Parent', panel, 'String', '+', 'Callback', ...
  @(~,~) incr_fig_nbr());

setx(btn, 0);
sety(btn, 100);
setwidth(btn, 100);
setheight(btn, 100);

btn = uicontrol('Parent', panel, 'String', '-', 'Callback', ...
  @(~,~) decr_fig_nbr());

setx(btn, 100);
sety(btn, 100);
setwidth(btn, 100);
setheight(btn, 100);

btn = uicontrol('Parent', panel, 'String', 'Update', 'Callback', ...
  @(~,~) update_fig_nbr());

setx(btn, 200);
sety(btn, 100);
setwidth(btn, 100);
setheight(btn, 100);

txt_ctrl = uicontrol('Parent', panel, 'Style', 'Text', 'String', ...
  '', 'Callback', ...
  @(~,~) update_fig_nbr());

setx(txt_ctrl, 300);
sety(txt_ctrl, 100);
setwidth(txt_ctrl, 100);
setheight(txt_ctrl, 100);

  function incr_fig_nbr()
    
    fignbrs = get_fig_nbrs();
    
    next_fig = fignbrs(find(fignbrs > figure_nbr, 1));
    
    if ~isempty(next_fig)
      figure_nbr = next_fig;
    end
    
    figure(figure_nbr);
    
    tot = length(fignbrs);
    ind = nnz(fignbrs<=figure_nbr);
    set(txt_ctrl, 'String', sprintf('%d out of %d', ind, tot)); 
  end


  function decr_fig_nbr()
    
    fignbrs = get_fig_nbrs();
    
    prev_fig = fignbrs(find(fignbrs < figure_nbr, 1, 'last'));
    
    if ~isempty(prev_fig)
      figure_nbr = prev_fig;
    end
    
    figure(figure_nbr);
    
    tot = length(fignbrs);
    ind = nnz(fignbrs<=figure_nbr);
    set(txt_ctrl, 'String', sprintf('%d out of %d', ind, tot));     
  end

  function update_fig_nbr()
    figure(figure_nbr);
  end

end

function nbrs = get_fig_nbrs()

figs = get_all_figures();
nbrs = sort(cell2mat({figs.Number}));

end
