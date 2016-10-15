function indx = match(obj, v, indx)

if nargin<3
	indx = 1:length(v) - obj.width;
else
	indx(indx>length(v) - obj.width) = [];
	indx = sort(indx);
end


keep_indx = false(size(indx));

for i=1:length(obj.width)
	dv = obj.height(i) / obj.width(i);

	count = 1;
	while count <= length(indx)
	
		j = indx(count);
		v0 = v(j);
	
		for k=1:obj.width(i)
			v0 = v0 + dv;
			vdiff = v(j+k) - v0;
		
			if vdiff > obj.upper_tol(i) || vdiff < obj.lower_tol(i)
				break
			end
		end
	
		if k==obj.width
			keep_indx(j) = true;
		end
	end
	
	indx = indx(keep_indx);
	
	if i==1
		indx = sc_separate(indx, obj.min_isi);
	end
end

end