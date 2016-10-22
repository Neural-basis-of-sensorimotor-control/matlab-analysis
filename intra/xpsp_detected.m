function val = xpsp_detected(xpsps, tmin, tmax)

val = false;

for i=1:length(xpsps)
  
  xpsp = xpsps(i);
  val = ~isempty(xpsp.gettimes(tmin, tmax));
  
  if val
    break
  end
end

end