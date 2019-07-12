clc
%first run define template module and define EPSP
waveform = defineTemplate.signal.waveforms.get(1);
all_templates = defineTemplate.getTriggableTemplates();
template = all_templates{1};
threshold_template = struct('indx_offset', template.position_offset, ...
    'lower_threshold', template.v_offset + template.lower_tolerance, ...
    'upper_threshold', template.v_offset + template.upper_tolerance);
n = round(length(defineTemplate.v)/10);
signal = struct('v', defineTemplate.v(1:n), 'dt', 1e-5);
ic_filtering(signal, threshold_template)
