function val = get_electrode(stim)

str = strsplit(stim, '#');
val =  str{2};

end