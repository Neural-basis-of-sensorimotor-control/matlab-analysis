function amplitudes = extract_single_amplitudes(amplitudes, stimelectrode)

str = get_single_amplitudes(stimelectrode);
amplitudes = amplitudes.match(str);

end