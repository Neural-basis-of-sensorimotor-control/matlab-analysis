function disable_panels(obj, panel)

index = obj.panels.indexof(panel);
if index>0
    for k=index:obj.panels.n
        if k>obj.panels.n
            break;
        else
            obj.panels.get(k).enabled = false;
        end
    end
end
% for k=1:obj.plots.n
%     cla(obj.plots.get(k).ax);
% end
end