function rise = get_normalized_rise(obj, rise)

tag = strsplit(obj.tag, '#');
str = tag{2};

single_pulse_rise = obj.parent.get_single_pulse_rise(str(2));

rise = rise/single_pulse_rise;

end