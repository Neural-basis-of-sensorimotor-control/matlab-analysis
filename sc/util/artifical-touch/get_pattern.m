function val = get_pattern(stim)

if ischar(stim)
  str = strsplit(stim, '#');
else
  str = strsplit(stim.tag, '#');
end

if ~isempty(str)
 val =  str{1};
else
  val = '{blank}';
end

end