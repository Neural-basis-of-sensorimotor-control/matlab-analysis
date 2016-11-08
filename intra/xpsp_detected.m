function val = xpsp_detected(psps, tmin, tmax)

val = false;

for i=1:length(psps)
  
  xpsp = psps(i);
  val = ~isempty(xpsp.gettimes(tmin, tmax));
  
  if val
    break
  end
end

end