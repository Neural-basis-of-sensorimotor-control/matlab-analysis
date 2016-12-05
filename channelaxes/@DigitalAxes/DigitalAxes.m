classdef DigitalAxes < ChannelAxes
	
	methods
		function obj = DigitalAxes(gui)
			obj@ChannelAxes(gui);
			sequence_listener();
			sc_addlistener(obj.gui,'xlimits',@xlimits_listener,obj.ax);
			sc_addlistener(obj.gui,'sequence',@sequence_listener,obj.ax);
			
			function xlimits_listener(~,~)
				if obj.gui.xlimits(1)<obj.gui.xlimits(2)
					xlim(obj.ax,obj.gui.xlimits);
				end
			end
			%
			function sequence_listener(~,~)
				if ~isempty(obj.gui.sequence)
					digch_ = obj.sequence.gettriggers(obj.gui.tmin,...
						obj.gui.tmax);
					height_ = max(15,digch_.n*15);
					setheight(obj.ax,height_);
					obj.height = height_;
				end
			end
			
		end
		
		function load_data(~)
		end
		
		function clear_data(~)
		end
		
		function plotch(obj,btn_down_fcn)
			if nargin==1
				btn_down_fcn = [];
			end
			sweep = obj.setup_axes();
			if ~isempty(sweep)
				digch = obj.sequence.gettriggers(obj.gui.tmin,...
					obj.gui.tmax);
				switch obj.gui.plotmode
					case {PlotModes.default, PlotModes.plot_all, ...
							PlotModes.plot_avg_all, PlotModes.plot_avg_selected, ...
							PlotModes.plot_avg_std_all, PlotModes.plot_avg_std_selected, ...
              PlotModes.plot_only_avg_std}
						pretrigger = obj.gui.pretrigger;
						posttrigger = obj.gui.posttrigger;
						if pretrigger>obj.gui.xlimits(1),   pretrigger = obj.gui.xlimits(1);    end
						if posttrigger<obj.gui.xlimits(2),  posttrigger = obj.gui.xlimits(2);   end
						for k=1:digch.n
							if isa(digch.get(k),'ScWaveform') || isa(digch.get(k),'ScRemoveWaveform')
								plotcolor = [1 1 1];
							else
								plotcolor = [.5 .5 0];
							end
							times = digch.get(k).perievent(obj.gui.triggertimes(sweep),...
								pretrigger,posttrigger);
							trange = [pretrigger; posttrigger];
							plot(obj.ax,trange,[k k],'Color',plotcolor);
							for j=1:numel(times)
								plot(obj.ax,times(j)*ones(2,1),k+[-.5 .5],'LineWidth',2,...
									'color',plotcolor,'ButtonDownFcn',btn_down_fcn);
							end
						end
				end
				set(obj.ax,'YLim',[0 digch.n+1],'YTick',...
					1:digch.n,'YTickLabel',digch.values('tag'),...
					'YColor',[1 1 1],'XColor',[0 0 0],'Color',[0 0 0]);
			else
				cla(obj.ax,'reset');
			end
			xlim(obj.ax,obj.gui.xlimits);
		end
	end
end
