function disable_panels(obj, panel)
obj.dbg_in(mfilename,'disable_panels');
index = obj.panels.indexof(panel);
for k=index:obj.panels.n
    obj.panels.get(k).enabled = false;
end
for k=1:obj.plots.n
    cla(obj.plots.get(k).ax);
end
obj.dbg_out(mfilename,'disable_panels');
end