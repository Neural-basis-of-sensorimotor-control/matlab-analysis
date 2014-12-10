classdef UpdatablePanel < Panel
    %Panel with a UpdatePanelButton
    methods
        function obj = UpdatablePanel(gui,panel)
            obj@Panel(gui,panel);
        end
        function setup_components(obj)
            obj.gui_components.add(UpdatePanelButton(obj));
        end
    end
end