function get_plotaxes(obj)

mgr = ScLayoutManager(obj.current_view);
mgr.leftindent = 2*obj.borderwidth + obj.leftpanelwidth;
obj.stimaxes = axes;
setheight(obj.stimaxes,obj.plotheight);
mgr.newline(getheight(obj.stimaxes));
mgr.add(obj.stimaxes);
obj.signalaxes = axes;
setheight(obj.signalaxes,obj.plotheight);
mgr.newline(getheight(obj.signalaxes));
mgr.add(obj.signalaxes);
for i=1:obj.extrasignalaxes.n
    obj.extrasignalaxes.get(i).axeshandle = axes(); %#ok<LAXES>
    setheight(obj.extrasignalaxes.get(i).axeshandle,obj.plotheight);
    mgr.newline(getheight(obj.extrasignalaxes.get(i).axeshandle));
    mgr.add(obj.extrasignalaxes.get(i).axeshandle);
end
obj.histogramaxes = axes;
setheight(obj.histogramaxes,obj.plotheight);
mgr.newline(getheight(obj.histogramaxes));
mgr.add(obj.histogramaxes);

addlistener(obj.signalaxes,'XLim','PostSet',@xlim_listener);

    function xlim_listener(~,~)
        xl = get(obj.signalaxes,'xlim');
        set(obj.stimaxes,'xlim',xl);
        for ii=1:obj.extrasignalaxes.n
            set(obj.extrasignalaxes.get(i).axeshandle,'xlim',xl);
        end
    end

set(pan(obj.current_view),'ActionPostCallback',@xlim_action_callback);
set(zoom(obj.signalaxes),'ActionPostCallback',@xlim_action_callback);

    function xlim_action_callback(~,~)
        xl = get(obj.signalaxes,'xlim');
        obj.xmin = xl(1);   obj.xmax = xl(2);
    end

end