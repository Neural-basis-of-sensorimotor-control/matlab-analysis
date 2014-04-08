function settextwidth(h,string)
letterwidth = 5;
set(h,'string',string);
minwidth = numel(string)*letterwidth; 
setwidth(h,minwidth);

