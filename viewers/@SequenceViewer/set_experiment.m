function set_experiment(obj,experiment)
obj.experiment = experiment;
if ~isempty(experiment)
    if ~isempty(experiment.save_name)
        p = fileparts(experiment.save_name);
        if ~isempty(p)
            obj.set_sc_file_folder(p);
        end
    end
    if isdir(experiment.fdir)
        obj.set_raw_data_folder(experiment.fdir);
    else
        if ~isempty(obj.raw_data_folder) || experiment.n
            if ~isempty(experiment.fdir)
                [~,experiment_folder] = fileparts(experiment.fdir);
            else
                experiment_folder = [];
            end
            filestr = experiment.get(1).filename;
            raw_folder_str = obj.raw_data_folder;
            nbr_of_chars = numel(raw_folder_str);
            at_root_level = false;
            found_dir = false;
            while ~at_root_level && ~found_dir
                f1 = sprintf('%s%s%s',raw_folder_str,filesep,filestr);
                f2 = sprintf('%s%s%s%s%s',raw_folder_str,filesep,experiment_folder,filesep,filestr);
                if exist(f1,'file') == 2
                    folder = raw_folder_str;
                    obj.set_raw_data_folder(folder);
                    experiment.fdir = folder;
                    found_dir = true;
                elseif exist(f2,'file') == 2
                    folder = sprintf('%s%s%s',raw_folder_str,filesep,experiment_folder);
                    obj.set_raw_data_folder(folder);
                    experiment.fdir = folder;
                    found_dir = true;
                else
                    if ~isempty(raw_folder_str)
                        raw_folder_str = fileparts(raw_folder_str);
                        at_root_level = numel(raw_folder_str) == nbr_of_chars;
                        nbr_of_chars = numel(raw_folder_str);
                    else
                        at_root_level = true;
                    end
                end
            end 
        end
    end
end
if ~isempty(experiment) && experiment.n    
    if ~isempty(obj.file)
        if obj.experiment.contains(obj.file)
            obj.set_file(obj.file);
        else
            obj.set_file(obj.experiment.get(1));
        end
    else
        obj.set_file(obj.experiment.get(1));
    end
else
    obj.set_file([]);
end

end