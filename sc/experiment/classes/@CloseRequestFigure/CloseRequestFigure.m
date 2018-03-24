classdef CloseRequestFigure < handle
  
  properties (Abstract)
    has_unsaved_changes
  end
  
  methods
    
    function close_request(obj)
      
      if obj.has_unsaved_changes
        
        option = questdlg('There are unsaved changes. Save before closing?',...
          'Close Request Function',...
          'Yes', 'No, close without saving', 'Cancel', 'Yes');
        
        if isempty(option)
          option = 'Cancel';
        end
        
        switch option
          
          case 'Yes'
            
            [~, save_path] = sc_settings.get_last_experiment();
            
            saved = obj.experiment.save_experiment(save_path, false);
            
            if saved
              
              obj.has_unsaved_changes = false;
              delete_figures();
              
            end
            
          case 'No, close without saving'
            
            delete_figures();
            
          case 'Cancel'
            
            return
            
          otherwise
            
            error(['debugging error: unknown option: ' option])
            
        end
        
      else
        
        delete_figures();
        
      end
      
    end
    
  end
end

function delete_figures()

f = get_all_figures();

indx = arrayfun(@(x) strcmp(get(x, 'Tag'), SequenceViewer.figure_tag), f);

f = f(indx);

for i=1:length(f)
  delete(f(i));
end

end