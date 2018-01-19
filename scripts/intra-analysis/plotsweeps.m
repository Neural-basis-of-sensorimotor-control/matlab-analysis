classdef plotsweeps
  
  methods (Static)
    
    function init(varargin)
      
      global SC_PLOT_SWEEPS
      
      SC_PLOT_SWEEPS = IntraPlotStates();
      SC_PLOT_SWEEPS.init(varargin{:});
      
    end

    
    function plot(neurons, str_stims, varargin)
      
      global SC_PLOT_SWEEPS
      
      SC_PLOT_SWEEPS.exec(neurons, str_stims, varargin{:});
      
    end
    
  end
  
end