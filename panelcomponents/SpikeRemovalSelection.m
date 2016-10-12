classdef SpikeRemovalSelection < PanelComponent
  properties
    ui_list
    ui_tstart
    ui_tstop
    ui_width
    ui_nbr_of_artifacts
    ui_import_current_wf
    ui_import_current_trg
    ui_delete_spike_removal
    ui_update_spike_removal
  end
  methods
    function obj = SpikeRemovalSelection(panel)
      obj@PanelComponent(panel);
      sc_addlistener(obj.gui,'rmwf',@(~,~) obj.rmwf_listener(),obj.uihandle);
    end
    function populate(obj,mgr)
      mgr.newline(20);
      mgr.add(sc_ctrl('text','Spike removal tool'),100);
      obj.ui_list = mgr.add(sc_ctrl('popupmenu',[],@(~,~) obj.list_callback,'visible','off'),100);
      mgr.newline(5);
      mgr.newline(20);
      mgr.add(sc_ctrl('text','tmin'),50);
      obj.ui_tstart = mgr.add(sc_ctrl('edit',[],@(~,~) obj.tstart_callback()),50);
      mgr.add(sc_ctrl('text','tmax'),50);
      obj.ui_tstop = mgr.add(sc_ctrl('edit',[],@(~,~) obj.tstop_callback()),50);
      mgr.newline(20);
      mgr.add(sc_ctrl('text','Filter width'),100);
      obj.ui_width = mgr.add(sc_ctrl('edit',[],@(~,~) obj.width_callback()),50);
      mgr.add(sc_ctrl('text','bins'),50);
      mgr.newline(20);
      obj.ui_nbr_of_artifacts = mgr.add(sc_ctrl('text',[]),200);
      mgr.newline(20);
      obj.ui_import_current_wf = mgr.add(sc_ctrl('pushbutton','Add waveform to spike removal list',@(~,~) obj.import_wf_callback),200);
      mgr.newline(20);
      obj.ui_import_current_wf = mgr.add(sc_ctrl('pushbutton','Add trigger to spike removal list',@(~,~) obj.import_trg_callback),200);
      mgr.newline(20);
      obj.ui_delete_spike_removal = mgr.add(sc_ctrl('pushbutton','Delete from spike removal list',@(~,~) obj.delete_spike_removal_callback),200);
      mgr.newline(20);
      obj.ui_update_spike_removal = mgr.add(sc_ctrl('pushbutton','Re-do spike removal calibration',@(~,~) obj.update_spike_removal_callback),200);
    end
    function initialize(obj)
      obj.rmwf_listener();
    end
  end
  methods (Access='protected')
    function rmwf_listener(obj)
      if isempty(obj.gui.rmwf)
        set(obj.ui_list,'visible','off');
        set(obj.ui_tstart,'visible','off');
        set(obj.ui_tstop,'visible','off');
        set(obj.ui_width,'visible','off');
        set(obj.ui_delete_spike_removal,'visible','off');
        set(obj.ui_update_spike_removal,'visible','off');
        set(obj.ui_nbr_of_artifacts,'visible','off');
      else
        list = obj.gui.main_signal.get_rmwfs(obj.sequence.tmin,obj.sequence.tmax);
        str = list.values('tag');
        val =  sc_cellfind(str,obj.gui.rmwf.tag);
        if numel(val)>1
          fprintf('Warning: >1 rmwf with identical names.\n');
          val = val(1);
        end
        set(obj.ui_list,'visible','on','string',str,'value',val);
        set(obj.ui_tstart,'visible','on','string',obj.gui.rmwf.tstart);
        set(obj.ui_tstop,'visible','on','string',obj.gui.rmwf.tstop);
        set(obj.ui_width,'visible','on','string',obj.gui.rmwf.width);
        set(obj.ui_delete_spike_removal,'visible','on');
        set(obj.ui_update_spike_removal,'visible','on');
        set(obj.ui_nbr_of_artifacts,'visible','on','string',...
          sprintf('Nbr of artifacts: %i\n',numel(obj.gui.rmwf.stimpos)));
        end
      end

      function list_callback(obj)
        list = obj.gui.main_signal.get_rmwfs(obj.sequence.tmin,obj.sequence.tmax);
        val = get(obj.ui_list,'value');
        obj.gui.rmwf = list.get(val);
      end

      function tstart_callback(obj)
        val = str2double(get(obj.ui_tstart,'string'));
        if ~isnumeric(val)
          msgbox('tmin has to be a numeric value [-inf, inf]');
          set(obj.ui_tstart,'string',obj.gui.rmwf.tstart);
        else
          obj.gui.rmwf.tstart = val;
          obj.update_spike_removal_callback();
        end
      end

      function tstop_callback(obj)
        val = str2double(get(obj.ui_tstop,'string'));
        if ~isnumeric(val)
          msgbox('tmax has to be a numeric value [-inf, inf]');
          set(obj.ui_tstop,'string',obj.gui.rmwf.tstop);
        else
          obj.gui.rmwf.tstop = val;
          obj.update_spike_removal_callback();
        end
      end

      function width_callback(obj)
        val = str2double(get(obj.ui_width,'string'));
        if ~isnumeric(val) || val<1 || mod(val,1)
          msgbox('Filter width has to be a positive integer');
          set(obj.ui_tstop,'string',obj.gui.rmwf.tstop);
        else
          obj.gui.rmwf.width = val;
          obj.gui.has_unsaved_changes = true;
        end
      end

      function import_wf_callback(obj)
        if isempty(obj.gui.waveform)
          msgbox('Cannot add. First choose a waveform');
        else
          obj.add_rmwf(obj.gui.waveform,obj.gui.waveform.width,true);
        end
      end
      function import_trg_callback(obj)
        trg = obj.gui.trigger;
        obj.add_rmwf(trg,500,false);
      end
      function add_rmwf(obj,trg,width,apply_calibration)
        list = obj.gui.main_signal.remove_waveforms;
        obj.gui.lock_screen(true,'Wait, calibrating waveform position...');
        obj.gui.has_unsaved_changes = true;
        obj.gui.main_channel.load_data();
        obj.show_panels(false);
        rmwf = ScRemoveWaveform(obj.gui.main_signal,trg,width,apply_calibration,obj.sequence.tmin,floor(obj.sequence.tmax));
        rmwf.calibrate(obj.gui.main_channel.v);
        list.add(rmwf);
        obj.gui.rmwf = rmwf;
        obj.gui.has_unsaved_changes = true;
        obj.gui.lock_screen(false);
        obj.automatic_update();

      end
      function delete_spike_removal_callback(obj)
        list = obj.gui.main_signal.get_rmwfs(obj.sequence.tmin,obj.sequence.tmax);%remove_waveforms;
        if ~list.n
          msgbox('Cannot remove. List is empty.')
        else
          val = get(obj.ui_list,'value');
          rmwf = list.get(val);
          obj.gui.main_signal.remove_waveforms.remove(rmwf);
          list = obj.gui.main_signal.get_rmwfs(obj.sequence.tmin,obj.sequence.tmax);
          if list.n
            obj.gui.rmwf = list.get(list.n);
          end
          obj.gui.has_unsaved_changes = true;
          obj.panel.initialize_panel();
        end
      end
      function update_spike_removal_callback(obj)
        obj.gui.has_unsaved_changes = true;
        obj.gui.lock_screen(true,'Wait, updating spike removal tool...');
        obj.gui.main_channel.load_data(false);
        list = obj.gui.main_signal.remove_waveforms;
        for k=1:list.n
          rmwf = list.get(k);
          rmwf.calibrate(obj.gui.main_channel.v);
          obj.gui.main_channel.v = rmwf.remove_wf(obj.gui.main_channel.v);
        end
        set(obj.ui_nbr_of_artifacts,'string',...
          sprintf('Nbr of artifacts: %i\n',numel(obj.gui.rmwf.stimpos)));
        obj.gui.has_unsaved_changes = true;
        obj.gui.lock_screen(false);
      end
    end
  end
