function return_fcn = invert_colormap(cmap)

return_fcn = @(x) ret_fcn(cmap, x);

end


function val = ret_fcn(cmap, x)

if nargin == 1
  val = cmap;
else
  val = cmap(x);
end

val = val(size(val,1):-1:1, :);

end