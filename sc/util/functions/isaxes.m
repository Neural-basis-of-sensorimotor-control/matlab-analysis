function val = isaxes(h)

val = isa(h, 'matlab.graphics.axis.Axes') || isa(h, 'GuiAxes');

end