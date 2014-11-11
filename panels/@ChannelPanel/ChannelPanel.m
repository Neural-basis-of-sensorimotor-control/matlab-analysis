classdef ChannelPanel < UpdatablePanel
    methods
        function obj = ChannelPanel(gui)            
            panel = uipanel('Parent',gui.btn_window,'Title','Channel selection');
            obj@UpdatablePanel(gui,panel);
            obj.layout();
        end
        
        function setup_components(obj)
            obj.gui_components.add(MainChannel(obj));
            obj.gui_components.add(SubChannels(obj));
            obj.gui_components.add(SetAxesHeight(obj));
            obj.gui_components.add(TriggerSelection(obj));
            obj.gui_components.add(FilterOptions(obj));
            obj.gui_components.add(PlotOptions(obj));
            obj.gui_components.add(WaveformSelection(obj));
            obj.gui_components.add(SpikeRemovalSelection(obj));
            setup_components@UpdatablePanel(obj);
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