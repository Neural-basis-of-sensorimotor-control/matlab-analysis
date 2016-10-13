function val = get_single_amplitudes(stimelectrode)

val = cell(10,1);

for i=1:length(val)
  val(i) = {sprintf('1p electrode %s#V%s#%d', stimelectrode, stimelectrode, i)};
end

end