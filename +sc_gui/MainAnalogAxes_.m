classdef MainAnalogAxes < sc_gui.AnalogAxes
    methods
        function obj = MainAnalogAxes(gui,signal,varargin)
            obj = obj@sc_gui.AnalogAxes(gui,signal,varargin{:});
        end
        
        function plotch(obj,varargin)
            switch obj.gui.plotmode
                case sc_gui.PlotModes.add_waveform_limits
                    varargin(end+1) = {'btn_down_fcn'};
                    varargin(end+1) = {@add_waveform_limits_callback};
            end
            plotch@sc_gui.AnalogAxes(obj,varargin{:})
        end
    end
end