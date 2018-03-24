function str_panels = get_panels()

str_panels = {
  {
  {'Reset'}
  {'pushbutton', [], 'Update', [], @(x, ~, ~) x.update(), 2*sc_tool.UiControl.default_width}
  {}
  {'text', 'm_help_text', @(x) x.help_text, 2,  @st_help_txt, sc_tool.UiControl.default_width, 2*sc_tool.UiControl.default_height}
  {}
  }
  
  {
  {'Plot options'}
  {'text', [], 'Plot mode'}
  {}
  {'popupmenu', 'm_plot_mode',  @gt_plot_modes, @(x) find(x.plot_mode == enumeration('sc_tool.PlotModeEnum')), @st_plot_mode, 2*sc_tool.UiControl.default_width}
  {}
%  {'text', [], 'Hist plot mode'}
%  {'edit', 'm_hist_plot_mode', @(x) x.hist_plot_mode, 0, @st_hist_plot_mode}
  {}
  }
  
  {
  {'Experiment'}
  {'text', [], 'Experiment'}
  {'text', 'm_experiment', @(x) x.experiment.save_name}
  {}
  {'text', [], 'File'}
  {'popupmenu', 'm_file', @(x) x.experiment.list, @(x) x.file,  @st_file}
  {}
  {'text', [], 'Sequence'}
  {'popupmenu', 'm_sequence', @(x) x.file.list,      @(x) x.sequence,  @st_sequence}
  {}
  {'text', [], 'Signal 1'}
  {'popupmenu', 'm_signal1', @(x) x.file.signals.list, @(x) x.signal1,      @st_signal1}
  {}
  {'text', [], 'Signal 2'}
  {'popupmenu', 'm_signal2', @(x) add_to_list(x.file.signals.cell_list, sc_tool.EmptyClass()), @(x) x.signal2,  @st_signal2}
  {}
  }
  
  {
  {'Trigger'}
  {'text', [], 'Trigger parent'}
  {'popupmenu', 'm_trigger_parent', @(x) x.get_triggerparents(), @(x) x.trigger_parent,  @st_trigger_parent}
  {}
  {'text', [], 'Trigger'}
  {'popupmenu', 'm_trigger', @(x) x.trigger_parent.get_triggers(), @(x) x.trigger,  @st_trigger}
  {}
  {'text', [], 'Trigger time'}
  {'edit', 'm_trigger_time', @(x) num2str(x.trigger_time), 0,  @st_trigger_time}
  {}
  {'text', 'm_trigger', @(x) sprintf('Trigger # (tot %d)',  length(x.all_trigger_times))}
  {'edit', 'm_trigger_indx', @(x) num2str(x.trigger_indx), 0,  @st_trigger_indx}
  {}
  {'text', [], 'Trigger increment'}
  {'edit', 'm_trigger_incr', @(x) x.trigger_incr, 1,  @st_trigger_incr}
  {}
  {'pushbutton', [], 'Previous', [], @callback_prev_trigger}
  {'pushbutton', [], 'Next', [], @callback_next_trigger}
  {}
  {'text', [], 'Pretrigger'}
  {'edit', 'm_pretrigger', @(x) num2str(x.pretrigger), 0,  @st_pretrigger}
  {}
  {'text', [], 'Posttrigger'}
  {'edit', 'm_posttrigger', @(x) num2str(x.posttrigger), 0,  @st_posttrigger}
  {}
  }
  
  {
  {'Axes height'}
  {'text', [], 'Trigger axes'}
  {'edit', 'm_trigger_axes', @(x) x.axes_height(1), 0,  @st_trigger_axes_height}
  {}
  {'text', [], 'Signal1 axes'}
  {'edit', 'm_signal1_axes', @(x) x.axes_height(2), 0,  @st_signal1_axes_height}
  {}
  {'text', [], 'Signal2 axes'}
  {'edit', 'm_signal2_axes', @(x) x.axes_height(3), 0,  @st_signal2_axes_height}
  {}
  {'pushbutton', [], 'Reset axes height', [], @callback_reset_axes_height, 2*sc_tool.UiControl.default_width}
  {}
  }
  
  {
  {'Filter options'}
  {'text', [], 'Smoothing width'}
  {'edit', 'm_signal1', @(x) x.signal1.filter.smoothing_width, 0, @st_smoothing_width}
  {}
  {'text', [], 'Artifact width'}
  {'edit', 'm_signal1', @(x) x.signal1.filter.artifact_width, 0, @st_artifact_width}
  {}
  {'text', [], 'Scale factor'}
  {'edit', 'm_signal1', @(x) x.signal1.filter.scale_factor, 0, @st_scale_factor}
  {}
  }
  
  {
  {'Plot options'}
  {'text', [], 'Set v = 0 for t = '}
  {'edit', [], @(x) x.v_zero_for_t, 0, @st_v_zero_for_t}
  {}
  {'checkbox', [], 'Plot stims', @(x) x.plot_stims, @st_plot_stims, 2*sc_tool.UiControl.default_width}
  {}
  {'pushbutton', [], 'Zoom', [], @callback_zoom}
  {'pushbutton', [], 'Pan', [], @callback_pan}
  {}
  {'pushbutton', [], 'X zoom in', [], @callback_xzoom_in}
  {'pushbutton', [], 'X zoom out', [], @callback_xzoom_out}
  {}
  {'pushbutton', [], 'Y zoom in', [], @callback_yzoom_in}
  {'pushbutton', [], 'Y zoom out', [], @callback_yzoom_out}
  {}
  }
  
  {
  {'Waveform'}
  {'text', [], 'Waveform'}
  {'popupmenu', 'm_waveform', @(x) x.signal1.waveforms.list, @(x) x.waveform, @st_waveform}
  {}
  {'text', [], 'Threshold'}
  {'popupmenu', 'm_threshold_indx', @(x) num2str(1:length(x.waveform.n)), @(x) x.threshold_indx, @st_threshold}
  {}
  {'pushbutton', 'm_signal1', 'New waveform', [], @callback_new_waveform}
  {'pushbutton', 'm_waveform', 'New template', [], @callback_new_threshold}
  {}
  {'pushbutton', 'm_waveform', 'Delete waveform', [], @callback_rm_waveform}
  {}
  {'pushbutton', 'm_waveform', 'Edit templates', [], @callback_edit_waveform}
  {'pushbutton', 'm_threshold_indx', 'Delete threshold', [], @callback_delete_threshold}
  {}
  {'pushbutton', 'm_waveform', 'Detect this waveform again', [], @callback_detect_this_waveform, 2*sc_tool.UiControl.default_width}
  {}
  {'pushbutton', 'm_waveform', 'Detect all waveforms again', [], @callback_detect_all_waveforms, 2*sc_tool.UiControl.default_width}
  {}
  {'pushbutton', 'm_waveform', 'Add manual spiketime', [], @callback_add_manual_spiketime, 2*sc_tool.UiControl.default_width}
  {}
  {'pushbutton', 'm_waveform', 'Remove manual spiketime', [], @callback_rm_manual_spiketime, 2*sc_tool.UiControl.default_width}
  {}
  }
  
%   {
%   {'Amplitude'}
%   {'text', [], 'Amplitude'}
%   {'popupmenu', 'm_amplitude', @(x) x.signal1.amplitudes.list, @(x) x.amplitude, @st_amplitude}
%   {}
%   {'pushbutton', 'm_signal1', 'New amplitude', [], @callback_add_amplitude}
%   {'pushbutton', 'm_amplitude', 'Delete amplitude', [], @callback_rm_amplitude}
%   {}
%   }
  
%   {
%   {'Histogram'}
%   {'text', [], 'Pretrigger'}
%   {'edit', 'm_hist_pretrigger', @(x) x.hist_pretrigger, 0, @st_hist_pretrigger}
%   {}
%   {'text', [], 'Posttrigger'}
%   {'edit', 'm_hist_posttrigger', @(x) x.hist_posttrigger, 0, @st_hist_posttrigger}
%   {}
%   {'text', [], 'Bin width'}
%   {'edit', 'm_hist_binwidth', @(x) x.hist_binwidth, 0, @st_hist_binwidth}
%   {}
%   }
  
%   {
%   {'Save as text file'}
%   {'text', [], 'Save signal', [], [],  2*sc_tool.UiControl.default_width}
%   {}
%   {'text', [], 'Save spike & trigger times', [], [],  2*sc_tool.UiControl.default_width}
%   {}
%   {'text', [], 'Save histogram', [], [],  2*sc_tool.UiControl.default_width}
%   {}
%   }
  
  };

end