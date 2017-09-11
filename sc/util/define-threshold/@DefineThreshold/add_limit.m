function add_limit(obj)

p = get(obj.h_axes, 'CurrentPoint');

x_ = p(1, 1);
y_ = p(1, 2);

if x_ <= obj.x0
  
  fprintf('x < x0. Discarding\n');
  
else
  
  n = length(obj.x) + 1;
  
  obj.x(n) = x_;
  
  if isempty(obj.x)
    
    dy = (obj.y_upper(n-1) - obj.y_lower(n-1))/2;
    
  else
    
    dy = sc_range(ylim(obj.h_axes))/2;
    
  end
  
  obj.y_upper(n) = y_ + dy;
  obj.y_lower(n) = y_ - dy;
  
  plot_single_limit(obj, n);
  
end

end