classdef AmplAnalogAxes < AnalogAxes
  
	methods
    
		function obj = AmplAnalogAxes(varargin)
      obj@AnalogAxes(varargin{:});
		end
		
		
		function plotv(obj, varargin)
      [v,time, handles] = plotv@AnalogAxes(obj, varargin{:});
			
      if size(v,2)==1
        set(handles,'HitTest','off');
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
        set(obj.ax,'ButtonDownFcn',@(~,~) define_amplitude_btndown(obj.gui));
      end
		end
		
	end
	
end


function define_amplitude_btndown(gui)

if gui.mouse_press>0
  p = get(gui.main_axes,'currentpoint');
  t0 = p(1,1); v0 = p(1,2);
	
  if t0<0
    gui.set_sweep(gui.sweep + 1);
  else
    stimtime = gui.triggertimes(gui.sweep(1));
    gui.amplitude.add_data(stimtime,2*gui.mouse_press-[1 0],[t0 v0]);
    gui.has_unsaved_changes = true;
		
    if gui.mouse_press == 1
      gui.set_mouse_press(2);
    else
      gui.set_sweep(gui.sweep + 1);
    end
  end
end

end

