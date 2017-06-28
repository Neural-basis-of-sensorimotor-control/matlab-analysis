function val = get_plot_markers(indx)

val = '.ox+*sdv^<>ph';

if nargin
	indx = mod(indx-1, length(val))+1;
	val = val(indx);
end

end