function [char_val, num_val] = get_electrode(stim)

str = strsplit(stim, '#');
char_val =  str{2};

if nargout>1
	num_val = str2double(char_val(2));
end

end