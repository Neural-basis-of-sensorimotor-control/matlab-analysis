function amplitudes = get_amplitudes(obj)

if isempty(obj.signal1)
  amplitudes = [];
else
  amplitudes = obj.signal1.amplitudes.list;
end

end

