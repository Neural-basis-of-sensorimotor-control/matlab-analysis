function add_limit(obj)

p = get(obj.h_axes, 'CurrentPoint');

x_ = p(1, 1);
y_ = p(1, 2);

if x_ <= obj.x0
  
  fprintf('x < x0. Discarding\n');
  return
  
elseif ~isempty(obj.x)
  
  dy = mean(obj.y_upper - obj.y_lower)/2;
  
else
  
  dy = sc_range(ylim(obj.h_axes))/10;
  
end

n = length(obj.x) + 1;

obj.x(n) = x_;
obj.y_upper(n) = y_ + dy;
obj.y_lower(n) = y_ - dy;

plot_single_limit(obj, n);

end