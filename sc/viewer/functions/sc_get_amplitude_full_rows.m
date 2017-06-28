function ind = sc_get_amplitude_full_rows(amplitude)
ind = all(~isnan(amplitude.data), 2);
end