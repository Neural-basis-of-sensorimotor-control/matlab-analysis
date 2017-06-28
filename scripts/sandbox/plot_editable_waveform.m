function plot_editable_waveform(h_axes, h_has_unsaved_changes, waveform, dt)

thresholds = waveform.get_thresholds();

edit_threshold(h_has_unsaved_changes, h_axes, thresholds, 0, 0, dt);

end
