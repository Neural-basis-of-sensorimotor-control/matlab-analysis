classdef ChannelPanel < UpdatablePanel
    %Abstract class
    methods (Abstract)
        setup_components(obj)
    end
    methods
        %overriding classes have to call obj.layout after creation of
        %constructor
        function obj = ChannelPanel(gui)
            panel = uipanel('Parent',gui.btn_window,'Title','Channel selection');
            obj@UpdatablePanel(gui,panel);
        end
        
        function update_panel(obj)
            if isempty(obj.gui.sequence)
                obj.enabled = false;
            else
                update_panel@Panel(obj);
                if obj.gui.show_digital_channels
                    obj.gui.digital_channels.load_data();
                end
                for k=1:obj.gui.analog_ch.n
                    obj.gui.analog_ch.get(k).load_data();
                end
                obj.sweep = obj.sweep(obj.sweep<=numel(obj.triggertimes));
                if isempty(obj.sweep) && numel(obj.triggertimes)
                    obj.sweep = 1;
                end
            end
            if ~numel(obj.gui.triggertimes)
                obj.enabled = false;
            end
            nextpanel = obj.gui.panels.get(obj.gui.panels.indexof(obj)+1);
            if obj.enabled
                nextpanel.initialize_panel();
                nextpanel.update_panel();
            else
                nextpanel.enabled = false;
            end
        end
    end
end