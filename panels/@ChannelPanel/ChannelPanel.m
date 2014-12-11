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
    end
end