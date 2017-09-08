function remove_limit(obj, indx)


obj.threshold.position_offset(indx) = [];
obj.threshold.v_offset(indx)        = [];
obj.threshold.upper_tolerance(indx) = [];
obj.threshold.lower_tolerance(indx) = [];

obj.define_threshold();

end