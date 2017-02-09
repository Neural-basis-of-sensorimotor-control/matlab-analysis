function val = get_pattern(stim)

if ischar(stim)
  str = strsplit(stim, '#');
else
  str = strsplit(stim.tag, '#');
end

val =  str{1};

end