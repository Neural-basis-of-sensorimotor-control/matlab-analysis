function clickToDrawTemplate(obj)

for i=1:length(obj.ephemeralPlots)
  if ishandle(obj.ephemeralPlots(i))
    delete(obj.ephemeralPlots(i));
  end
end
obj.ephemeralPlots = [];

currentPoint = obj.axes22.CurrentPoint;
x            = currentPoint(1, 1);
y            = currentPoint(1, 2);
template     = obj.getSelectedTemplate();
obj.ephemeralPlots = template.plotShape(obj.axes22, x, y);

end
