function val = startswithi(str, start)

val = length(str) >= length(start) && strcmpi(str(1:length(start)), start); 