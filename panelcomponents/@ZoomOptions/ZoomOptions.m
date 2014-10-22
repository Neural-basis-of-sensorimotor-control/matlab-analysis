classdef ZoomOptions < PanelComponent
    properties
        ui_zoom
        ui_pan
    end
    
    methods
        function obj = ZoomOptions(panel)
            obj@PanelComponent(panel);
            
            sc_addlistener(obj.gui,'zoom_on',@(~,~) obj.toggle_button('zoom_on',obj.ui_zoom),panel);
            sc_addlistener(obj.gui,'pan_on',@(~,~) obj.toggle_button('pan_on',obj.ui_pan),panel);
            
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            obj.ui_zoom = mgr.add(sc_ctrl('pushbutton','Manual zoom',@(~,~) obj.zoom_callback),100);
            obj.ui_pan = mgr.add(sc_ctrl('pushbutton','Pan',@(~,~) obj.pan_callback),100);
            mgr.newline(20);
            mgr.add(sc_ctrl('pushbutton','Reset',@(~,~) obj.reset_callback),100);
            mgr.newline(20);
            mgr.add(sc_ctrl('pushbutton','X zoom in',@(~,~) obj.x_zoom_in_callback),100);
            mgr.add(sc_ctrl('pushbutton','X zoom out',@(~,~) obj.x_zoom_out_callback),100);
            mgr.newline(20);
            mgr.add(sc_ctrl('pushbutton','Y zoom in',@(~,~) obj.y_zoom_in_callback),100);
            mgr.add(sc_ctrl('pushbutton','Y zoom out',@(~,~) obj.y_zoom_out_callback),100);
        end
        
    end
    
    methods (Access = 'protected')
        
        function toggle_button(obj,property, button)
            if obj.gui.(property)
                set(button,'FontWeight','bold');
            else
                set(button,'FontWeight','normal');
            end
        end
        
        function zoom_callback(obj)
            obj.gui.zoom_on = ~obj.gui.zoom_on;
        end
        
        function pan_callback(obj)
            obj.gui.pan_on = ~obj.gui.pan_on;
        end
        
        function reset_callback(obj)
            ylim(obj.gui.main_axes,'auto');
            obj.gui.xlimits = [obj.gui.pretrigger obj.gui.posttrigger];
            obj.gui.zoom_on = false;
            obj.gui.pan_on = false;
            obj.gui.plot_channels();
        end
        function x_zoom_in_callback(obj)
            xlimits = xlim(obj.gui.main_axes);
            xdiff = diff(xlimits);
            xlimits(1) = xlimits(1) +xdiff/4;
            xlimits(2) = xlimits(2) -xdiff/4;
            xlim(obj.gui.main_axes,xlimits);
        end
        
        function x_zoom_out_callback(obj)
            xlimits = xlim(obj.gui.main_axes);
            xdiff = diff(xlimits);
            xlimits = xlimits + [-xdiff/2 xdiff/2];
            xlim(obj.gui.main_axes,xlimits);
        end
        
        function y_zoom_in_callback(obj)
            ylimits = ylim(obj.gui.main_axes);
            ydiff = diff(ylimits);
            ylimits(1) = ylimits(1) +ydiff/4;
            ylimits(2) = ylimits(2) -ydiff/4;
            ylim(obj.gui.main_axes,ylimits);
        end
        
        function y_zoom_out_callback(obj)
            ylimits = ylim(obj.gui.main_axes);
            ydiff = diff(ylimits);
            ylimits = ylimits + [-ydiff/2 ydiff/2];
            ylim(obj.gui.main_axes,ylimits);
        end

    end
    
end