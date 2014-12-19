classdef ModifyThresholdGui < handle
    properties
        original_threshold
        threshold
        has_unsaved_changes
        v
        triggertimes
        sweepnbr
        window
        sweep_threshold
    end
    properties (Dependent)
        get_window
    end
    methods
        function obj = ModifyThresholdGui(threshold,v,triggertimes,sweepnbr)
            obj.has_unsaved_changes = false;
            obj.original_threshold = threshold;
            obj.threshold = threshold.create_copy();
            obj.v = v;
            obj.triggertimes = triggertimes;
            obj.sweepnbr = sweepnbr;
            obj.sweep_threshold = SweepThresholdGui();
        end
        function show(obj)
            obj.get_window();
            
        end
        function window = get.get_window(obj)
            if isempty(obj.window) || ~ishandle(obj.window)
                obj.window = figure();
                set(obj.window,'ResizeFcn',@(~,~) obj.resize_window(),...
                    'CloseRequestFcn',@(~,~) obj.close_request());
            end
            window = obj.window;
        end
        function resize_window(obj)
        end
        function close_request(obj)
            delete(obj.window);
        end
    end
end