function val = xpsp_detected(psps, tmin, tmax)

val = false;

for i=1:length(psps)
  
  xpsp = get_item(psps, i);
  %TODO: add check if isempty
  val = ~isempty(xpsp.gettimes(tmin, tmax));
  
  if val
    break
  end
end

end