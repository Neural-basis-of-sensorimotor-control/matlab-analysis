function sc_tile_axes()

f = findall(0, 'Type', 'figure');
for i=1:length(f)
  fig = f(i);
  position = fig.Position;
  width = position(3);
  height = position(4);
  
  children = get(fig,'children');
  nbrofaxes = length(children);
  nbrofrows = ceil(sqrt(nbrofaxes));
  nbrofcols = ceil(nbrofaxes/nbrofrows);
  
  axeswidth = width/nbrofcols;
  axesheight = height/nbrofrows;
  
  rownbr = 1;
  colnbr = 1;
  for k = length(children):-1:1
    c = children(k);
    x = (colnbr-1)*axeswidth;
    y = height-rownbr*axesheight;
    set(c,'Unit','pixels');
    set(c,'outerposition',[x y axeswidth axesheight])
    colnbr = colnbr + 1;
    if colnbr > nbrofcols
      colnbr = 1;
      rownbr = rownbr + 1;
    end
  end
end
end