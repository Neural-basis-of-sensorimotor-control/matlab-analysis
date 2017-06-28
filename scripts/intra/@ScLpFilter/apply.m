function v = apply(obj, v)

if size(v,2) > 1
	
	for i=1:size(v,2)
		v(:,i) = obj.apply(v(:,i));
	end
	
	return
end

for i=1:obj.width_indx:length(v)
	indx = (i-1 + (1:obj.width_indx))';
	indx(indx>length(v)) = [];
	
	[p, ~, mu] = polyfit(indx, v(indx), obj.polynomial_nbr);

	v(indx) = v(indx) - polyval(p, indx, [], mu);

end