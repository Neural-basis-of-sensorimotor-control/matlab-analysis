classdef CascadeItem < sc_gui.UiWrapper
    properties
        updated = false
        parent
    end
    
    methods (Abstract)
        initialize(obj)
        update(obj)
    end
    
    properties (Dependent)
        next
    end
    
    methods
        function obj = CascadeItem(varargin)
            obj@sc_gui.UiWrapper(varargin{:});
        end
        
        function setvisible(obj,visible)
            if visible
                set(obj,'visible','on');
            else
                set(obj,'visible','off');
            end
            if ~isempty(obj.next)
                obj.next.setvisible(visible && obj.updated);
            end
        end
        
        function next = get.next(obj)
            next = [];
            break_loop = false;
            for k=1:obj.parent.n
                if break_loop
                    next = obj.parent.get(k);
                    break
                end
                if obj.parent.get(k) == obj
                    break_loop = true;
                end
            end
        end
    end
end