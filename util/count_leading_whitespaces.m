function val = count_leading_whitespaces(str)
%COUNT_LEADING_WHITESPACES Count the number of whitespaces in char array.
%
% VAL = COUNT_LEADING_WHITESPACES STR returns the number of leading
% whitespace characters of input char array STR

%	Created by Hannes Mogensen
if ~ischar(str)
  error('Input must be a char array');
end

val = 0;

while true

  if val + 1 > length(str) || str(val+1) ~= ' '
    return
  end

  val = val + 1;

end
