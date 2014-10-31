classdef ScExperiment < ScList
%Children: ScFile    
    properties
        fdir        %directory containing .mat / .adq files
        sc_dir      %directory for save_name (where this object is saved)
        save_name   %for saving this class, ends with _sc.mat
        last_gui_version
    end
    
    properties (Dependent)
        abs_save_path
    end
    
    methods
        function obj = ScExperiment(varargin)
            for i=1:2:numel(varargin)
                obj.(varargin{i}) = varargin{i+1};
            end
        end
                
        %Save current object
        %   showdialog  if true, user can update obj.save_name
        function saved = sc_save(obj, showdialog)
            if nargin<2,    showdialog = true;  end
            saved = false;
            if showdialog || isempty(obj.abs_save_path) || exist(obj.abs_save_path,'file') ~= 2
                [fname, pname] = uiputfile('*_sc.mat','Choose file to save',...
                    obj.save_name);
                if ~isnumeric(fname)
                    obj.sc_dir = pname;
                    obj.save_name = fname;
                    save(obj.abs_save_path,'obj');
                    saved = true;
                end
            else
                save(obj.abs_save_path,'obj');
                saved = true;
            end
        end
        
        %clear all transient data
        function sc_clear(obj)
            for i=1:obj.n
                obj.get(i).sc_clear();
            end
        end
        
        %Populate all children
        function init(obj)
            for i=1:obj.n
                fprintf('reading file: %i out of %i\n',i,obj.n);
                obj.get(i).init();
            end
        end
        
        %Parse experimental protocol (*.txt)
         function update_from_protocol(obj, protocolfile)
             for i=1:obj.n
                 fprintf('parsing file %i out of %i\n',i,obj.n);
                 obj.get(i).update_from_protocol(protocolfile);
             end
         end
         
         function val = get.abs_save_path(obj)
             val = fullfile(obj.sc_dir,obj.save_name);
         end
    end
end