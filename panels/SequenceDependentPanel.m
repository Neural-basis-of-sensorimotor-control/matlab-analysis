classdef SequenceDependentPanel < Panel
    methods
        function obj = SequenceDependentPanel(gui,panel)
            obj@Panel(gui,panel);
        end
        
        function initialize_panel(obj)
            if ~isempty(obj.gui.sequence)
                initialize_panel@Panel(obj);
            end
        end
        
        function update_panel(obj)
            if isempty(obj.gui.sequence)
                obj.enabled = false;
            else
                update_panel@Panel(obj);
            end
        end
    end
end