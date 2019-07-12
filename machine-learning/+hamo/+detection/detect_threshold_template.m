function indx = detect_threshold_template(v, waveform)

indx = 1:length(v);
for i=1:length(waveform.time_indx)
    relative_signal = v(indx+waveform.time_indx(i))-v(indx);
    within_threshold = relative_signal > waveform.lower_threshold(i) & ...
        relative_signal < waveform.upper_threshold(i);
    indx = indx(within_threshold);
end

end
