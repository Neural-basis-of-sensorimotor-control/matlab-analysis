classdef AbstractWaveformPanelComponent < PanelComponent
  %Contains functions to update gui.waveform property
  methods
    function obj = AbstractWaveformPanelComponent(varargin)
      obj@PanelComponent(varargin{:})
    end
    %Update all waveforms in gui.main_channel.waveforms list
    function update_all_waveforms(obj)
      obj.gui.lock_screen(true,'Recalculating all waveforms, might take a minute...');
      obj.show_panels(false);
      obj.gui.has_unsaved_changes = true;
      obj.gui.main_channel.signal.recalculate_all_waveforms();
      obj.gui.lock_screen(false);
      obj.automatic_update();
    end
    %Update only waveform referenced in gui.waveform property
    function update_current_waveform(obj)
      obj.gui.lock_screen(true,'Recalculating current waveform, might take a minute...');
      obj.gui.has_unsaved_changes = true;
      obj.gui.main_channel.signal.recalculate_waveform(obj.gui.waveform);
      obj.gui.lock_screen(false);
      obj.automatic_update();
    end
  end
end
