function [titles, components] = get_panels()

titles      = {};
components  = {};

titles = add_to_list(titles, 'Experiment');
titles = add_to_list(titles, 'Triggers');

components = add_to_list(components, {
  'text'      'Experiment'      []            []                                   []
  'text'      @get_save_name    []            []                                   []
  'text'      'File'            []            []                                   []
  'popupmenu' @get_files        @(x) x.file      @(x, ~, indx) x.set_file(indx)     'file'
  'text'      'Sequence'        []            []                                   []
  'popupmenu' @get_sequences    @(x) x.sequence  @(x, ~, indx) x.set_sequence(indx) 'sequence'
  'text'      'Signal1'         []            []                                   []
  'popupmenu' @get_signals      @(x) x.signal1   @(x, ~, indx) x.set_signal1(indx)  'signal1'
  'text'      'Signal2'         []            []                                   []
  'popupmenu' @get_signals      @(x) x.signal2   @(x, ~, indx) x.set_signal2(indx)  'signal2'
  'text'      'Waveform'        []            []                                   []
  'popupmenu' @get_waveforms    @(x) x.waveform  @(x, ~, indx) x.set_waveform(indx)  'waveform'
  'text'      'Amplitude'        []            []                                   []
  'popupmenu' @get_amplitudes   @(x) x.amplitude @(x, ~, indx) x.set_amplitude(indx)  'amplitude'
  });

components = add_to_list(components, {
  'text'      'Trigger parent'        []                    []                                   []
  'popupmenu' @get_trigger_parents @(x) x.trigger_parent @(x, ~, indx) x.set_trigger_parent(indx) 'trigger_parent'
  'text'      'Trigger tag'        []                    []                                   []
  'popupmenu' @get_trigger_tags @(x) x.trigger_tag @(x, ~, indx) x.set_trigger_tag(indx) 'trigger_tag'
  });


end