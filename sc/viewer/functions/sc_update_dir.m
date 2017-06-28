function new_dir = sc_update_dir(old_dir, base_dir, searchfor, prompt_before_update)

if nargin<3,    searchfor = 'dir';              end
if nargin < 4,  prompt_before_update = false;   end

if isempty(old_dir), old_dir = '';  end
if isempty(base_dir), base_dir = '';  end


new_dir = old_dir;
if exist(old_dir, searchfor)
  return
end

new_dir = strrep(new_dir, '/', filesep);
if exist(new_dir, searchfor)
  return
end

new_dir = strrep(new_dir, '\', filesep);
if exist(new_dir, searchfor)
  return
end

filesep_ind = strfind(new_dir, filesep);
filesep_ind = [0 filesep_ind];
%filesep_ind = filesep_ind(length(filesep_ind):-1:1);


for j=1:length(filesep_ind)
  temp_dir = [base_dir new_dir(filesep_ind(j)+1:end)];
  if exist(temp_dir, searchfor)
    if prompt_before_update
      answer = questdlg(sprintf('Change dir to %s?', temp_dir), 'Yes', 'No', 'No');
      switch answer
        case 'Yes'
          new_dir = temp_dir;
        end
      else
        new_dir = temp_dir;
      end
      return
    end
  end


  %
  %
  %
  %
  % save_dir_separated = strsplit(new_dir, filesep);
  % save_dir_separated = save_dir_separated(length(save_dir_separated):-1:1);
  %
  % for i=1:length(base_dir)
  %   path_str = '';
  %   for j=1:length(save_dir_separated)
  %     path_str = [save_dir_separated{j} filesep path_str]; %#ok<AGROW>
  %     temp_dir = [base_dir{i} path_str];
  %     if exist(temp_dir, searchfor)
  %       new_dir = temp_dir;
  %       return
  %     end
  %   end
  % end
  %
  end
