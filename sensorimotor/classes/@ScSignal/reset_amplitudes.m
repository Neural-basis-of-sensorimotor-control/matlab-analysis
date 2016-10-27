function reset_amplitudes(obj)

for i=1:obj.amplitudes.n
	
	amplitude = obj.amplitudes.get(i);
	amplitude.is_updated = false;
	
end

end