function add_x_offset(obj, x_offset)

%check thresholds

if x_offset < 0
  
  if min(obj.position_offset) <= -x_offset
    error('x_offset < position_offset');
  end
  
end

obj.position_offset = obj.position_offset + x_offset;

end
  
    