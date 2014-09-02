classdef GuiManager < handle
    properties
        sequence
        leftcolumn
        rightcolumn
        
        stimaxes
        main_signalaxes
        extra_signalaxes
        
        histaxes
        
        sweepnbr
        pretrigger
        posttrigger
        
        sc_xlim
        sc_ylim
    end
    
    methods
        function sc_plot(obj)
            obj.stimaxes.sc_plot();
            obj.main_signalaxes.sc_plot();
            for i=1:obj.extra_signalaxes.n
                obj.extra_signalaxes.get(i).sc_plot();
            end
        end
    end
end