classdef DefineSpike < handle

	properties
		x
		y
		dt
		spike
		x0
		y0
		update_fcn
	end
	
	methods
		
		function obj = DefineSpike()
			obj.update_fcn = @obj.define_spike_update;
		end
		
		function update(obj)
			obj.update_fcn();
		end
		
	end
	
	methods (Static)
	
		function ds = define(x, y, dt)
			ds = DefineSpike;
			ds.define_spike(x, y, dt);
		end
		
	end

end