classdef ScExperiment < ScList
    
    properties
        fdir
        save_name
    end
    
    methods
        function obj = ScExperiment(varargin)
            for i=1:2:numel(varargin)
                obj.(varargin{i}) = varargin{i+1};
            end
        end
                
        function saved = sc_save(obj, showdialog)
            saved = false;
            if nargin<2 || showdialog || isempty(obj.save_name)
                [fname, pname] = uiputfile('*_sc.mat','Choose file to save',...
                    obj.save_name);
                if ~isnumeric(fname)
                    file = fullfile(pname,fname);
                    obj.save_name = fname;
                    save(file,'obj');
                    saved = true;
                end
            else
                save(fullfile(obj.fdir,obj.save_name),'obj');
                saved = true;
            end
        end
        
        function sc_clear(obj)
            for i=1:obj.n
                obj.get(i).sc_clear();
            end
        end
        
        function init(obj)
            for i=1:obj.n
                fprintf('reading file: %i out of %i\n',i,obj.n);
                obj.get(i).init();
            end
        end
        
         function update_from_protocol(obj, protocolfile)
             for i=1:obj.n
                 fprintf('parsing file %i out of %i\n',i,obj.n);
                 obj.get(i).update_from_protocol(protocolfile);
             end
         end
    end
end