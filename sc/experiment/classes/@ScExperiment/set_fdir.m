function set_fdir(obj, folders)

folders = strrep(folders, '/', filesep);
folders = strrep(folders, '\', filesep);
obj.fdir = folders;

ind = find(folders == filesep, 1, 'last');

set_raw_data_dir(folders(1:ind));

end