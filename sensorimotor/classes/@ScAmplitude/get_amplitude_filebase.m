function filebase = get_amplitude_filebase(amplitude)

file_tag = amplitude.parent.parent.tag;
signal_tag = amplitude.parent.tag;
amplitude_tag = amplitude.tag;

filebase = sprintf('%s_%s_%s_ampl', file_tag, signal_tag, amplitude_tag);

end