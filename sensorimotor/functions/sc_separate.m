function x_separated = sc_separate(x,min_spacing)

x =sort(x);
x_separated = nan(size(x));

if numel(x_separated)
	pos = 1;
	x_separated(1) = x(1);
	
	for i=2:numel(x)
		if x(i)-x_separated(pos)>=min_spacing
			pos = pos+1;
			x_separated(pos) = x(i);
		end
	end
	
	x_separated = x_separated(1:pos);
end

end
