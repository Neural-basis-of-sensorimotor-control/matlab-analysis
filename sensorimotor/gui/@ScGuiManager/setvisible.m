function setvisible(obj, visible)

if visible
    str = 'on';
else
    str = 'off';
end

setv(obj.triggerpanel);
setv(obj.plotpanel);
setv(obj.waveformpanel);
setv(obj.histogrampanel);
setv(obj.savepanel);

    function setv(panel)
        if ishandle(panel)
            set(panel,'visible',str);
        end    
    end

end