clear
close all
f = figure;

mgr = sc_layout.FigureLayoutManager(f);

for i=1:10
  
  p = uipanel;
  
  mgr2 = sc_layout.PanelLayoutManager(p);
  mgr2.add(uicontrol('style', 'pushbutton', 'String', '1'), 100);
  mgr2.add(uicontrol('style', 'pushbutton', 'String', '2'), 100);
  mgr2.newline;
  mgr2.add(uicontrol('style', 'pushbutton', 'String', '3'), 200);
  mgr2.trim;
  
  mgr.add(p, 200)
  mgr.newline();
  
end

mgr.trim