classdef DefineSpike < handle

	properties
    
    v
		dt
		threshold
		x0
		y0
    h_axes
    title_str
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
	
		function ds = define(v, dt)

			ds        = DefineSpike;
      ds.h_axes = gca;
      
			ds.define_spike(v, dt);
      
		end
		
	end

end