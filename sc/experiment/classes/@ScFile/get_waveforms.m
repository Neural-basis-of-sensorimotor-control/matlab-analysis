function val = get_waveforms(obj, tmin, tmax)

val = [];

for i=1:obj.signals.n
  
  signal = obj.signals.get(i);
  
  if nargin == 1
    
    val = concat_list(val, signal.waveforms.list);
  
  else
    
    for j=1:signal.waveforms.n
      
      waveform = signal.waveforms.get(j);
      
      if nargin == 1 || ~isempty(waveform.gettimes(tmin, tmax))
        val = add_to_list(val, waveform);
      end
      
    end
    
  end
  
end

end