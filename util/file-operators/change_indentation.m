function change_indentation(directory, indentation_spaces)
%CHANGE_INDENTATION Change indentation recursively of .m files in directory
%
% CHANGE_INDENTATION DIRECTORY INDENTATION_SPACES searches through the
% directory DIRECTORY recursively for all .m files and changes the 
% indentation to INDENTATION_SPACES. If DIRECTORY is a .m file, indentation
% will be changed for this file. The files must be indented using spaces
% (not tabs).
%

%	Created by Hannes Mogensen, Lund University

if endswith(directory, '.m') && exist(directory, 'file')
  change_file_indentation(directory, indentation_spaces);
  return
end

s = dir(directory);

is_dir = cell2mat({s.isdir}) & ~endswith({s.name}, '.');
is_m_file = ~is_dir & endswith({s.name}, '.m');

files = {s(is_m_file).name};

dirs = {s(is_dir).name};

for i=1:length(files)
  change_file_indentation([directory filesep files{i}], indentation_spaces);
end

for i=1:length(dirs)
  change_indentation([directory filesep dirs{i}], indentation_spaces);
end
