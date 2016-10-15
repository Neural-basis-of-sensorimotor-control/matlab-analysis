function change_file_indentation(filename, indentation_spaces)
%CHANGE_FILE_INDENTATION Change indentation of file
%
%	CHANGE_FILE_INDENTATION FILENAME INDENTATION_SPACE changes the
%	indentation of file FILENAME to INDENTATION_SPACE. File must be indented
%	using spaces, not tabs.
%

% Created by Hannes Mogensen, Lund University

fprintf('%s\n', filename);

tempfilename = [tempname '.m'];

movefile(filename, tempfilename);

originalfid = fopen(tempfilename, 'r');
newfid = fopen(filename, 'w');

nbr_of_spaces_prev_line = 0;
alignment_level = 0;

while 1
	original_line = fgetl(originalfid);
	
	if isnumeric(original_line)
		fclose(newfid);
		fclose(originalfid);
		delete(tempfilename);
		return
	end
	
	nbr_of_spaces = count_leading_whitespaces(original_line);
	
	if nbr_of_spaces == length(original_line)
		%Remove trailing whitespace
		original_line = '';
		
	elseif nbr_of_spaces > nbr_of_spaces_prev_line
		%Alignment increasing by 1
		alignment_level = alignment_level + 1;
		nbr_of_spaces_prev_line = nbr_of_spaces;
		
	elseif nbr_of_spaces < nbr_of_spaces_prev_line
		%Alignment decreasing by 1
		alignment_level = alignment_level - 1;
		nbr_of_spaces_prev_line = nbr_of_spaces;
		
	end
	
	newline =  original_line(nbr_of_spaces+1:end);
	
	%Add indentation
	if ~isempty(newline)
		newline = [repmat(' ', 1, alignment_level*indentation_spaces) newline];
	end
	
	fprintf(newfid, '%s\n', newline);
	
end
