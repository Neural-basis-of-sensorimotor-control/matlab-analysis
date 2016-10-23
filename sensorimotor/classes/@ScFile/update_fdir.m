function update_fdir(obj)

default_dir = get_raw_data_dir();

if isempty(default_dir)
	return
end

filepath = update_filepath(obj.filepath, default_dir);

if exist(filepath, 'file')
	obj.parent.fdir = fileparts(filepath);
end

end