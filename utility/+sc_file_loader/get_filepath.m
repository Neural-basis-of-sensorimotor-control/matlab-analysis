function [filepath, last_file, last_dir] = ...
  get_filepath(str_file, str_dir, recursive_depth)

filepath  = '';
last_file = '';
last_dir  = '';

[enc_file, n_file] = separate_str(str_file);
[enc_dir, n_dir]   = separate_str(str_dir);

for i_file=n_file:-1:1
  
  for i_dir=0:n_dir
    
    tmp_filepath = concat_filepath(enc_file, i_file, enc_dir, i_dir);
    
    if is_file(tmp_filepath)
      
      filepath                   = tmp_filepath;
      [enc_filepath, n_filepath] = separate_str(filepath);
      last_file                  = concat_file(enc_filepath, recursive_depth);
      last_dir                   = concat_dir(enc_filepath, n_filepath - recursive_depth);
      return
      
    end
  end
end

end


function filepath = concat_filepath(enc_file, i_file, enc_dir, i_dir)

filepath = [concat_dir(enc_dir, i_dir) concat_file(enc_file, i_file)];

end


function str_dir = concat_dir(enc_dir, i_dir)

if i_dir > 0
  str_dir = enc_dir{1};
else
  str_dir = '';
end

for i=2:i_dir
  str_dir = [str_dir filesep enc_dir{i}]; %#ok<AGROW>
end

if ~isempty(str_dir)
  str_dir = [str_dir filesep];
end

end


function str_file = concat_file(enc_file, i_dir)

n_dir = length(enc_file);

if i_dir > 0
  str_file = enc_file{end};
else
  str_file = '';
end

for i=(n_dir-1):-1:(n_dir-i_dir+1)
  str_file = [enc_file{i} filesep str_file]; %#ok<AGROW>
end

end


function [enc_str, n_enc] = separate_str(str)

str = strrep(str, '/', filesep);
str = strrep(str, '\', filesep);

initialFileSep = ~isempty(str) && str(1) == filesep;

enc_str = strsplit(str, filesep);
if initialFileSep
  enc_str(2:end+1) = enc_str;
  enc_str(1) = {filesep};
end

for i=length(enc_str):-1:1
  
  if isempty(enc_str{i})
    enc_str(i) = [];
  end
  
end

n_enc = length(enc_str);

end
%if 
  % && (endsWith(filepath, '.adq') || ...
%  endsWith(filepath, '.mat'))