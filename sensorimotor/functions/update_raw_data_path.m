function val = update_raw_data_path(raw_data_file)

if isempty(raw_data_file)
  error('Raw data file is empty');
end

if exist(raw_data_file, 'file')
  val = raw_data_file;
else
  [folder, file, ext] = fileparts(raw_data_file);
  
  folder = strrep(folder, '/', filesep);
  folder = strrep(folder, '\', filesep);
  
  folder = strsplit(folder, filesep);
  folder = folder{end};

  val = [get_raw_data_dir() folder filesep file ext];
  
  while ~exist(val, 'file')
    folder = uigetdir(get_raw_data_dir(), ...
      ['Choose raw data directory for ' raw_data_file]);
    
    if isnumeric(folder)
      val = [];
    else
      val = [folder filesep file ext];
    end
  end
end