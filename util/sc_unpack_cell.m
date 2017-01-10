function val = sc_unpack_cell(x)

val = {};

if ~iscell(x)
  val = x;
  
else
  x = x(:);
  
  for i=1:length(x)
    xx = sc_unpack_cell(x{i});
    
    if iscell(xx)
      val(length(val)+1:length(val)+length(xx)) = xx;
    else
      val(length(val)+1) = {xx};
    end
  end
end

end