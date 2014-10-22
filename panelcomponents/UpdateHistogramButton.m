classdef UpdateHistogramButton < UpdatePanelButton
    methods
        function obj = UpdateHistogramButton(panel)
            obj@UpdatePanelButton(panel);
        end
    end
    methods (Access='protected')
        function update_callback(obj)
            obj.gui.lock_screen(true,'Wait, plotting histogram ...');
            obj.gui.histogram.plotch();
            obj.gui.lock_screen(false);
        end
    end
end