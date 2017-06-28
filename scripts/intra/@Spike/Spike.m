classdef Spike < handle
	
	properties
		height
		width
		lower_tol
		upper_tol
		min_isi
	end
	
	properties (Dependent)
		n
	end
	
	methods
		
		function val = get.n(obj)
			val = length(obj.height);
		end
		
	end

end