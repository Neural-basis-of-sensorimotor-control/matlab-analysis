classdef SetAxesHeight < PanelComponent
    properties
        fighandle
    end
    methods
        function obj = SetAxesHeight(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            mgr.add(sc_ctrl('pushbutton','Set plot heights',@(~,~) obj.setheights_callback),200);
        end
    end
    
    methods (Access = 'protected')
        function setheights_callback(obj)
            obj.fighandle = figure('WindowStyle','modal','CloseRequestFcn',@(~,~) obj.close_req_fcn);
            newpanel = uipanel('parent',obj.fighandle);
            mgr = ScLayoutManager(newpanel,'panelwidth',205);
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Plot type'),100);
            mgr.add(sc_ctrl('text','height'),100);
            for k=1:obj.gui.plots.n
                thischannel = obj.gui.plots.get(k); 
                mgr.newline(20);
                mgr.add(sc_ctrl('text',class(thischannel)),100);
                mgr.add(sc_ctrl('edit',getheight(thischannel.ax),@(src,~) edit_callback(obj,src,thischannel.ax)),100);
            end
            mgr.newline(20);
            mgr.add(sc_ctrl('pushbutton','OK',@(~,~) obj.ok_btn()),200);
            mgr.newline(2);
            mgr.trim();
            figmgr = ScLayoutManager(obj.fighandle,'panelwidth',getwidth(newpanel)...
                ,'panelheight',getheight(newpanel));
            figmgr.newline(getheight(newpanel));
            figmgr.add(newpanel);
            figmgr.trim();
        end
    end
    
    methods (Access = 'protected')
        function edit_callback(~,thisedit,ax)
            height = str2double(get(thisedit,'string'));
            setheight(ax,height);
        end
        function ok_btn(obj)
            close(obj.fighandle);
        end
        function close_req_fcn(obj)
            delete(obj.fighandle);
            obj.gui.resize_plot_window();
        end
    end
end