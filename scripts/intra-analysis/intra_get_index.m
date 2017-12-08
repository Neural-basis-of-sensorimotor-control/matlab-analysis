function str_indx = intra_get_index(stim)

if ischar(stim)
  str = strsplit(stim, '#');
else
  str = strsplit(stim.tag, '#');
end

if length(str)>=3
  str_indx =  str{3};
else
  str_indx = '{blank}';
end

end