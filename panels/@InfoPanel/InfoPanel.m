classdef InfoPanel < Panel & MainPanel & SequenceTextBox & UpdateButton & ChannelOptions
    methods
        function obj = InfoPanel(gui)
            panel = uipanel('Parent',gui.current_view,'Title','Main');
            obj@Panel(gui,panel);
            obj@MainPanel(gui,panel);
            obj@SequenceTextBox(gui);
            obj@UpdateButton(gui);
            obj@ChannelOptions(gui,panel);
        end
        
        function populate_panel(obj,mgr)
            populate_panel@UpdateButton(obj,mgr);
            populate_panel@MainPanel(obj,mgr);
            populate_panel@SequenceTextBox(obj,mgr);
            populate_panel@ChannelOptions(obj,mgr);
        end
        
        function initialize_panel(obj)
            initialize_panel@MainPanel(obj);
            initialize_panel@SequenceTextBox(obj);
            initialize_panel@ChannelOptions(obj);
        end
        
        function update_panel(obj)
        end
    end
end