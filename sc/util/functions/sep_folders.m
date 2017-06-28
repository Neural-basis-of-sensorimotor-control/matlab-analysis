function val = sep_folders(str)

val = {};

if isempty(str)
	return;
elseif str(1) == '/' || str(1) == '\'
	str = str(2:end);
	val(1) = {filesep};
end

indx = sort([strfind(str, '/') strfind(str, '\')]);

pos = 1;
count = 1;

while count<=length(indx)	
	val(end+1) = {str(pos:indx(count)-1)};
	pos = indx(count)+1;
	count = count +1;
end

val(end+1) = {str(pos:end)};





