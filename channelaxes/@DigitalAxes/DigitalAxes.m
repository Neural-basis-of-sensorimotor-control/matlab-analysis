classdef DigitalAxes < ChannelAxes
    
    methods
        function obj = DigitalAxes(gui)
            obj@ChannelAxes(gui);
%             digch = obj.sequence.gettriggers(obj.gui.tmin,...
%                 obj.gui.tmax);
%             setheight(obj.ax,digch.n*15);
            sc_addlistener(obj.gui,'xlimits',@xlimits_listener,obj.ax);
            
            function xlimits_listener(~,~)
                if obj.gui.xlimits(1)<obj.gui.xlimits(2)
                    xlim(obj.ax,obj.gui.xlimits);
                end
            end
            
            sc_addlistener(obj.gui,'sequence',@sequence_listener,obj.ax);
            
            function sequence_listener(~,~)
                if ~isempty(obj.gui.sequence)
                    digch_ = obj.sequence.gettriggers(obj.gui.tmin,...
                        obj.gui.tmax);
                    setheight(obj.ax,digch_.n*15);
                end
            end
            
        end
        
        function load_data(~)
        end
        
        function clear_data(~)
        end
        
        function plotch(obj)%,varargin)
            sweep = obj.setup_axes();%,varargin{:});
            
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
            %    xlim(obj.ax,obj.gui.xlimits);
        end
    end
end