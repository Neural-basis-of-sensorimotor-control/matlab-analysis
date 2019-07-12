function indx = detect_threshold_template(v, threshold_template)

w = max(threshold_template.indx_offset);
indx = 1:(length(v)-w+1);
for i=1:length(threshold_template.indx_offset)
    relative_signal = v(indx+threshold_template.indx_offset(i))-v(indx);
    within_threshold = relative_signal > threshold_template.lower_threshold(i) & ...
        relative_signal < threshold_template.upper_threshold(i);
    indx = indx(within_threshold);
end
indx = sc_separate(indx, floor(w/5));

end
