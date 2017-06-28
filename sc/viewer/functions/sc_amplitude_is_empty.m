function is_empty = sc_amplitude_is_empty(amplitude)
if length(amplitude) > 1
  is_empty = false(size(amplitude));
  for i=1:length(amplitude)
    is_empty(i) = sc_amplitude_is_empty(amplitude(i));
  end
else
  is_empty = ~any(sc_get_amplitude_full_rows(amplitude));
end

end