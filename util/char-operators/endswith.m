function val = endswith(str, ending)
%ENDSWITH Check string ending
%
%	VAL = ENDSWITH STR ENDING returns true if char array STR ends with char
%	array ENDING. If STR is a cell array of char arrays, VAL is a logical
%	array.

%	Created by Hannes Mogensen
if iscell(str)
  val = false(size(str));

  for i=1:length(str)
    val(i) = endswith(str{i}, ending);
  end
else
  if ~ischar(str)
    error('Input must be a char or cell array of chars');
  end

  val = length(str) >= length(ending) && strcmp(str(end-length(ending)+1:end), ending);
end
