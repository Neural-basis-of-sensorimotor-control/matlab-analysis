function indx = detect_threshold_template(v, threshold_template)

indx = 1:length(v);
for i=1:length(threshold_template.indx_offset)
    relative_signal = v(indx+threshold_template.indx_offset(i))-v(indx);
    within_threshold = relative_signal > threshold_template.lower_threshold(i) & ...
        relative_signal < threshold_template.upper_threshold(i);
    indx = indx(within_threshold);
end

end
