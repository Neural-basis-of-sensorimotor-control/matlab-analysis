function fill_space(parent, h)

margin = 20;

setheight(h, getheight(parent)-2*margin);
setwidth(h, getwidth(parent)-2*margin);
setx(h, margin);
sety(h, margin);

end