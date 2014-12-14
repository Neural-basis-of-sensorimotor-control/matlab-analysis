function set_sweep(obj,sweep)
obj.sweep = mod(sweep-1,numel(obj.triggertimes))+1;
obj.plot_channels();
end