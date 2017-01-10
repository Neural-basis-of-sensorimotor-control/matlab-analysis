function sc_maximize_all()
% SC_MAXIMIZE_ALL Maximize all open figures
screensize = get(0,'screensize');
screenwidth = screensize(3);
screenheight = .9*screensize(4);
f = findall(0, 'Type', 'figure');
for i=1:length(f)
  setx(f(i),0);
  sety(f(i),0);
  setwidth(f(i),screenwidth);
  setheight(f(i),screenheight);
end