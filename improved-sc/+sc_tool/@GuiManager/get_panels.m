function str_panels = get_panels()
% 1  style
% 2  property
% 3  get_string
% 4  get_value
% 5  callback
% 6  property_listener
% 7  width
% 8  height
str_panels = {
  {
  {'Reset'}
  {'pushbutton', [], 'Update', [], @(x, ~, ~) x.update(), [], 2*sc_tool.UiControl.default_width}
  {}
  {'pushbutton', 'm_enabled', 'Reset', [], @callback_enable, @enable_listener, 2*sc_tool.UiControl.default_width}
  {}
  {'text', 'm_help_text', @(x) x.help_text, 2,  @st_help_txt, [],  sc_tool.UiControl.default_width, 2*sc_tool.UiControl.default_height}
  {}
  }
  
  {
  {'Plot options'}
  {'text', [], 'Plot mode'}
  {}
  {'popupmenu', 'm_plot_mode',  @gt_plot_modes, @(x) find(x.plot_mode == enumeration('sc_tool.PlotModeEnum')), @st_plot_mode, [], 2*sc_tool.UiControl.default_width}
  {}
  }
  
  {
  {'File selection'}
  {'pushbutton', [], 'Save', [], @(x) sc_save(x, false)}
  {'pushbutton', [], 'Save As', [], @(x) sc_save(x, true)}
  {}
  {'pushbutton', [], 'Load', [], @(~) spikeviewer('-forceload'), [], 2*sc_tool.UiControl.default_width}
  {}
  {'pushbutton', [], 'New Spike2 set', [], @(~) spikeviewer('-newsp2')}
  {'pushbutton', [], 'New .adq set', [], @(x) spikeviewer('-newadq')}
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
  {'pushbutton', 'm_file', 'Add sequence', [], @callback_add_sequence}
  {'pushbutton', 'm_experiment', 'Parse protocol', [], @callback_parse_protocol}
  {}
  {'pushbutton', 'm_experiment', 'Edit sequence', [], @callback_print_protocol}
  {'pushbutton', 'm_experiment', 'Remove sequence', [], @callback_print_summary}
  {}
  {'pushbutton', 'm_experiment', 'Print protocol', [], @callback_print_protocol}
  {'pushbutton', 'm_experiment', 'Print summary', [], @callback_print_summary}
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
  {'pushbutton', [], 'Reset axes height', [], @callback_reset_axes_height, [], 2*sc_tool.UiControl.default_width}
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
  {'Spike removal'}
  {'text', [], 'Spike removal'}
  {'popupmenu', 'm_remove_waveform', @(x) x.signal1.remove_waveforms.list, @(x) x.remove_waveform, @st_remove_waveform}
  {}
  {'text', [], 'tmin', [], [], [], sc_tool.UiControl.default_width/2}
  {'edit', 'm_remove_waveform', @(x) x.remove_waveform.tmin, [], @st_remove_waveform_tmin, [], sc_tool.UiControl.default_width/2}
  {'text', [], 'tmax', [], [], [], sc_tool.UiControl.default_width/2}
  {'text', 'm_remove_waveform', @(x) x.remove_waveform.tmax, [], @st_remove_waveform_tmax, [], sc_tool.UiControl.default_width/2}
  {}
  {'text', [], 'Filter width'}
  {'edit', 'm_remove_waveform', @(x) x.remove_waveform.width, [], @st_remove_waveform_width}
  {}
  {'text', 'm_remove_waveform', @(x) sprintf('Nbr of detections: %d', length(x.signal1.remove_waveform.stimpos)), [], [], [], 2*sc_tool.UiControl.default_width}
  {}
  {'pushbutton', 'm_waveform', 'Add waveform to spike removal list', [], @callback_add_wf_to_remove_wf, [], 2*sc_tool.UiControl.default_width}
  {}
  {'pushbutton', 'm_trigger', 'Add trigger to spike removal list', [], @callback_add_trigger_to_remove_wd, [], 2*sc_tool.UiControl.default_width}
  {}
  {'pushbutton', 'm_remove_waveform', 'Delete from spike removal list', [], @callback_delete_remove_wf, [], 2*sc_tool.UiControl.default_width}
  {}
  {'pushbutton', 'm_remove_waveform', 'Redo spike removal calibration', [], @callback_redo_remove_wf_calibration, [], 2*sc_tool.UiControl.default_width}
  {}
  }
  
  {
  {'Plot options'}
  {'text', [], 'Set v = 0 for t = '}
  {'edit', [], @(x) x.v_zero_for_t, 0, @st_v_zero_for_t}
  {}
  {'checkbox', [], 'Plot stims', @(x) x.plot_stims, @st_plot_stims, [], 2*sc_tool.UiControl.default_width}
  {}
  {'pushbutton', [], 'Zoom', [], @callback_zoom, @btn_listener_zoom}
  {'pushbutton', [], 'Pan', [], @callback_pan, @btn_listener_pan}
  {}
  {'pushbutton', [], 'Reset', [], @callback_reset_zoom, [], 2*sc_tool.UiControl.default_width}
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
  {'pushbutton', 'm_signal1', 'New waveform', [], @callback_new_waveform}
  {'pushbutton', 'm_waveform', 'Delete waveform', [], @callback_rm_waveform}
  {}
  {'pushbutton', 'm_waveform', 'Add template', [], @callback_add_thresholds}
  {'pushbutton', 'm_waveform', 'Remove template', [], @callback_rm_threshold}
  {}
  {'pushbutton', 'm_waveform', 'Modify templates', [], @callback_modify_threshold}
  {}
  {'pushbutton', 'm_interactive_mode', 'Done', [], @callback_done, @btn_listener_interactive_mode}
  {}
  {'pushbutton', 'm_waveform', 'Add manual spiketime', [], @callback_add_manual_spiketime, [], 2*sc_tool.UiControl.default_width}
  {}
  {'pushbutton', 'm_waveform', 'Remove manual spiketime', [], @callback_rm_manual_spiketime, [], 2*sc_tool.UiControl.default_width}
  {}
  {'pushbutton', 'm_waveform', 'Detect this waveform again', [], @callback_detect_this_waveform, [], 2*sc_tool.UiControl.default_width}
  {}
  {'pushbutton', 'm_waveform', 'Detect all waveforms again', [], @callback_detect_all_waveforms, [], 2*sc_tool.UiControl.default_width}
  {}
  }
  
  {
  {'Amplitude'}
  {'text', [], 'Amplitude'}
  {'popupmenu', 'm_amplitude', @(x) x.signal1.amplitudes.list, @(x) x.amplitude, @st_amplitude}
  {}
  {'pushbutton', 'm_signal1', 'New amplitude', [], @callback_add_amplitude}
  {'pushbutton', 'm_amplitude', 'Delete amplitude', [], @callback_rm_amplitude}
  {}
  }
  
  {
  {'Histogram'}
  {'text', [], 'Pretrigger'}
  {'edit', 'm_hist_pretrigger', @(x) x.hist_pretrigger, 0, @st_hist_pretrigger}
  {}
  {'text', [], 'Posttrigger'}
  {'edit', 'm_hist_posttrigger', @(x) x.hist_posttrigger, 0, @st_hist_posttrigger}
  {}
  {'text', [], 'Bin width'}
  {'edit', 'm_hist_binwidth', @(x) x.hist_binwidth, 0, @st_hist_binwidth}
  {}
  {'text', [], 'Hist plot mode'}
  {}
  {'edit', 'm_hist_plot_mode', @(x) x.hist_plot_mode, [], @st_hist_plot_mode}
  {}
  }
  
  {
  {'Save as text file'}
  {'text', [], 'Save signal', [], [],  [], 2*sc_tool.UiControl.default_width}
  {}
  {'text', [], 'Save spike & trigger times', [], [],  [], 2*sc_tool.UiControl.default_width}
  {}
  {'text', [], 'Save histogram', [], [],  [], 2*sc_tool.UiControl.default_width}
  {}
  }
  
  };

end