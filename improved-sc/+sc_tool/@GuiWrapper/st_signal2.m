function st_signal2(obj, ~, val)

if val > obj.file.signals.n
  obj.signal2 = sc_tool.EmptyClass();
else
  obj.signal2 = obj.file.signals.get(val);
end

end