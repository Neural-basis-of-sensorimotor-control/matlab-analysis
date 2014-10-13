function plot_channels(obj,btndownfcn)
if nargin<2,    btndownfcn = [];    end
for k=1:obj.plots.n
    if obj.plots.get(k).ax == obj.main_axes
        obj.plots.get(k).plotch(btndownfcn);
    else
        obj.plots.get(k).plotch();
    end
end
end