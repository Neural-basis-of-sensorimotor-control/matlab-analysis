function update_property_values(obj)

for i=1:obj.waveforms.n
  obj.waveforms.get(i).update_property_values();
end

end