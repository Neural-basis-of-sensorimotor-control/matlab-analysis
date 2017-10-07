function add_x_offset(obj, x_offset)

%check thresholds

if x_offset < 0
  
  for i=1:obj.n
    
    if min(obj.get(i).position_offset) <= -x_offset
      error('x_offset < position_offset');
    end
    
  end
  
end

for i=1:obj.n
  
  obj.get(i).add_x_offset(x_offset);
  
end

end
  
    