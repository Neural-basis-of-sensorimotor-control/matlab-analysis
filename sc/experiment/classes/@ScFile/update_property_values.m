function update_property_values(obj)

for i=1:obj.signals.n
  obj.signals.get(i).update_property_values();
end

end