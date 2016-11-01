classdef AmplAnalogAxes < AnalogAxes
  
	methods
    
		function obj = AmplAnalogAxes(varargin)
      obj@AnalogAxes(varargin{:});
		end
		
		
		function plotv(obj, varargin)
      [v,time] = plotv@AnalogAxes(obj, varargin{:});
			
      if size(v,2)==1
        [~,ind] = min(abs(time));
        text(0,double(v(ind)),'start','HorizontalAlignment',...
          'center','Color',[0 1 0],'parent',obj.ax,'HitTest','off');
        triggertime = obj.gui.triggertimes(obj.gui.sweep(1));
        val = obj.gui.amplitude.get_data(triggertime,1:4);
      
				if isfinite(val(1))
          plot(obj.ax,val(1),val(2),'g+','MarkerSize',6,'LineWidth',2,'HitTest','off');
				end
        
        if isfinite(val(3))
          plot(obj.ax,val(3),double(val(4)),'b+','MarkerSize',6,'LineWidth',2,'HitTest','off');
        end
        
        set(obj.ax, 'ButtonDownFcn',@(~,~) obj.define_amplitude_btndown);
      end
		end
		
	end
	
end


