function set_fdir(obj, folders)

folders = strrep(folders, '/', filesep);
folders = strrep(folders, '\', filesep);
obj.fdir = folders;

end