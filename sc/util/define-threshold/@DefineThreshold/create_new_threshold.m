function create_new_threshold(obj)

obj.clear_settings();

if ~isempty(obj.threshold)
  obj.waveform.add(obj.threshold);
end

obj.define_threshold();

end