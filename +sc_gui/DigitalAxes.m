classdef DigitalAxes < sc_gui.ChannelAxes
    
    methods
        function obj = DigitalAxes(gui)
            obj = obj@sc_gui.ChannelAxes(gui);
            digch = obj.sequence.gettriggers(obj.gui.tmin,...
                obj.gui.tmax);
            setheight(obj.ax,digch.n*15);
        end
        
        function plotch(obj,varargin)
            sweep = obj.setup_axes(obj,varargin{:});
            
            if ~isempty(sweep)
                digch = obj.sequence.gettriggers(obj.gui.tmin,...
                    obj.gui.tmax);
                switch obj.gui.plotmode
                    case sc_gui.PlotModes.default
                        for k=1:digch.n
                            if isa(digch.get(k),'ScWaveform')
                                plotcolor = [1 1 1];
                            else
                                plotcolor = [.5 .5 0];
                            end
                            times = digch.get(k).perievent(obj.gui.triggertimes(sweep),...
                                obj.gui.pretrigger,obj.gui.posttrigger);
                            trange = [obj.gui.pretrigger; obj.gui.posttrigger];
                            plot(obj.ax,trange,[k k],'Color',plotcolor);
                            for j=1:numel(times)
                                plot(obj.ax,times(j)*ones(2,1),k+[-.5 .5],'LineWidth',2,...
                                    'color',plotcolor);
                            end
                        end
                end
                set(obj.ax,'YLim',[0 digch.n+1],'YTick',...
                    1:digch.n,'YTickLabel',digch.values('tag'),...
                    'YColor',[1 1 1],'XColor',[0 0 0],'Color',[0 0 0]);
            else
                cla(obj.ax);
            end
        end
    end
end