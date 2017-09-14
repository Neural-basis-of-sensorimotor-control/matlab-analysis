function val = get_single_pulse_rise(obj, ind)

if isnumeric(ind)
	ind = num2str(ind);
end

rise_amplitude = [];

for i=1:10
  
	str = sprintf('1p electrode %s#V%s#%d', ind, ind, i);
	
	if obj.amplitudes.has('tag', str)
    
		amplitude = obj.amplitudes.get('tag', str);
		rise_amplitude = [rise_amplitude; amplitude.rise_automatic_detection];
    
	end
	
end

val = mean(rise_amplitude);

end