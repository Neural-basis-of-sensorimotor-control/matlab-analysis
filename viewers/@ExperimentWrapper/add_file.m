function add_file(obj)

raw_data_files = uigetfile({'*.mat', '*.adq'}, ...
  'Select all files with analog channels to be included', ...
  obj.experiment.fdir, 'MultiSelect','on');

if ~iscell(raw_data_files)
  raw_data_files = {raw_data_files};
end

raw_data_files = raw_data_files(cellfun(@(x) ~isempty(x), raw_data_files));

for i=1:numel(raw_data_files)
  fprintf('scanning file %i out of %i\n',i,numel(raw_data_files));
  
  file = ScFile(obj.experiment, raw_data_files{i});
  file.init();
  obj.experiment.add(file);
end

if ~isempty(raw_data_files)
  obj.has_unsaved_changes = true;
end

end