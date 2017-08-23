function brwfig

btn_width = 100;
btn_height = 100;

figure_nbr = min(get_fig_nbrs());
fig = figure();
set(fig, 'Tag', 'browser');

panel = uipanel('Parent', fig);

x = 0;
y = 100;

btn = uicontrol('Parent', panel, 'String', '-', 'Callback', ...
  @(~,~) decr_fig_nbr());
[x, y] = add_btn(btn, x, y, btn_height, btn_width);

btn = uicontrol('Parent', panel, 'String', '+', 'Callback', ...
  @(~,~) incr_fig_nbr());
[x, y] = add_btn(btn, x, y, btn_height, btn_width);

btn = uicontrol('Parent', panel, 'String', 'Close', 'Callback', ...
  @(~,~) close_fig());
[x, y] = add_btn(btn, x, y, btn_height, btn_width);

btn = uicontrol('Parent', panel, 'String', 'Update', 'Callback', ...
  @(~,~) update_fig_nbr());
[x, y] = add_btn(btn, x, y, btn_height, btn_width);

txt_ctrl = uicontrol('Parent', panel, 'Style', 'Text', 'String', ...
  '', 'Callback', ...
  @(~,~) update_fig_nbr());
add_btn(btn, x, y, btn_height, btn_width);


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

    fignbrs = get_fig_nbrs();
    tot = length(fignbrs);
    ind = nnz(fignbrs<=figure_nbr);
    set(txt_ctrl, 'String', sprintf('%d out of %d', ind, tot));
  end

  function close_fig()
    
    close(figure_nbr);
    
    incr_fig_nbr();
    
  end

end


function [x, y] = add_btn(btn, x, y, height, width)

setx(btn, x);
sety(btn, height);
setwidth(btn, width);
setheight(btn, y);

x = x + width;


end

function nbrs = get_fig_nbrs()

figs = get_all_figures();
nbrs = sort(cell2mat({figs.Number}));

end
