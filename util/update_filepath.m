function val = update_filepath(filepath, alternative_dir)

val = [];

if exist(filepath, 'file')
	val = filepath;
else
	filepath = sep_folders(filepath);
	val = alternative_dir;
	
	for i=length(filepath):-1:1
		val = [val filesep filepath{i}];
	end
end

end