classdef SavePlotOptions < PanelComponent
    properties
    end
    
    methods
        function obj = SavePlotOptions(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            fprintf('to be implemnted: SavePLotOptions');
        end
        
        function initialize(obj)

        end
        
    end
    
    methods (Access = 'protected')
    end
    
end