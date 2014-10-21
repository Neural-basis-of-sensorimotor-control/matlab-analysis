function disable_panels(obj, panel)

index = obj.panels.indexof(panel);
for k=index:obj.panels.n
    if k>obj.panels.n
        break;
    else
        obj.panels.get(k).enabled = false;
    end
end
for k=1:obj.plots.n
    cla(obj.plots.get(k).ax);
end
end