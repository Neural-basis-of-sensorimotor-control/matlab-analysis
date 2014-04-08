classdef ScChannel < handle
    
    properties
        channelname
        parent
        tag
    end
    
    properties (Dependent)
%         tmin
%         tmax
        fdir
        is_adq_file
    end
    
    methods
        
%         function tag = get.tag(obj)
%             tag = obj.channelname;
%         end
        
%         function tmin = get.tmin(obj)
%             tmin = obj.parent.tmin;
%         end
%         
%         function tmax = get.tmax(obj)
%             tmax = obj.parent.tmax;
%         end
        
        function fdir = get.fdir(obj)
            fdir = obj.parent.fdir;
        end
        
        function is_adq_file = get.is_adq_file(obj)
            is_adq_file = obj.parent.is_adq_file;
        end
        
    end
    
    methods (Static = true)
        function obj = loadobj(a)
            if ~a.is_adq_file() && isempty(a.tag)
                a.tag = a.channelname;
            end
            obj = a;
        end
    end
end
    