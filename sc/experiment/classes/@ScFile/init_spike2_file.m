function success = init_spike2_file(obj)

obj.add_spike2_channels();

for i=1:obj.stims.n
  obj.stims.get(i).sc_loadtimes;
end

for i=1:obj.signals.n
  obj.signals.get(i).filter.update_stims();
end

for i=1:obj.stims.n
  obj.stims.get(i).sc_clear;
end

success = true;

end
