classdef WaveformSelection < AbstractWaveformPanelComponent
	
	properties
		ui_waveforms
		ui_remove
		ui_nbr_of_spikes
	end
	
	methods
		
		function obj = WaveformSelection(varargin)
			obj@AbstractWaveformPanelComponent(varargin{:});
		end
		
		function populate(obj,mgr)
			mgr.newline(20);
			mgr.add(sc_ctrl('text','Waveform'),100);
			obj.ui_waveforms = mgr.add(sc_ctrl('popupmenu', [], ...
        @(~,~) obj.change_waveform_callback(),'visible','off'), 100);
			mgr.newline(5)
			mgr.newline(20);
			obj.ui_nbr_of_spikes = mgr.add(sc_ctrl('text',[]),200);
			mgr.newline(20);
			mgr.add(sc_ctrl('pushbutton','New waveform',@(~,~) add_waveform_callback(obj)),100);
			obj.ui_remove = mgr.add(sc_ctrl('pushbutton','Remove waveform',@(~,~) remove_waveform_callback(obj)),100);
			mgr.newline(20)
			mgr.add(sc_ctrl('pushbutton','Export waveform',@(~,~) obj.export_waveform()),100);
			mgr.newline(20)
			mgr.add(sc_ctrl('pushbutton','Detect all waveforms again',@(~,~) obj.update_all_waveforms),200);
			mgr.newline(20)
			mgr.add(sc_ctrl('pushbutton','Detect this waveform again',@(~,~) obj.update_current_waveform),200);
			
			sc_addlistener(obj.gui,'waveform',@(~,~) obj.waveform_listener, obj.uihandle);
			
			function add_waveform_callback(objh)
				objh.gui.create_new_waveform;
				objh.show_panels(false);
				objh.automatic_update();
			end
			
			function remove_waveform_callback(objh)
				if isempty(objh.gui.waveform)
					msgbox('No waveform selected. Cannot remove');
				else
					answer = questdlg(sprintf('Are you sure you want to remove waveform %s including all its thresholds (=templates)?',...
						objh.gui.waveform.tag));
					if strcmp(answer,'Yes')
						prev_index = objh.gui.panels.indexof(objh.panel)-1;
						prev_panel = objh.gui.panels.get(prev_index);
						objh.gui.disable_panels(prev_panel);
						objh.gui.main_signal.waveforms.remove(objh.gui.waveform);
						objh.gui.set_main_signal(objh.gui.main_signal);
						objh.gui.has_unsaved_changes = true;
						objh.show_panels(false);
						objh.automatic_update();
					end
				end
			end
		end
		
		function initialize(obj)
			
			if isempty(obj.gui.waveform)
				set(obj.ui_waveforms,'visible','off');
			else
				set(obj.ui_waveforms,'visible','on');
			end
		end
		
		function waveform_listener(obj)
      
			if isempty(obj.gui.waveform)
				set(obj.ui_remove,'enable','off');
			else
				set(obj.ui_remove,'enable','on');
				set(obj.ui_nbr_of_spikes,'string',sprintf('Nbr of spikes in this sequence: %i',numel(obj.gui.waveform.gettimes(obj.gui.sequence.tmin,obj.gui.sequence.tmax))));
			end
			
			if ~isempty(obj.gui.waveform)
				wf = obj.gui.waveform;
				str = obj.gui.main_signal.waveforms.values('tag');
				ind = find(cellfun(@(x) strcmp(x, wf.tag), str));
				if nnz(ind) > 1
					error('>1 waveform with identical name');
				end
				set(obj.ui_waveforms, 'string', str, 'value', ind, 'visible', 'on');
				set(obj.ui_nbr_of_spikes, 'string', ...
					sprintf('Nbr of spikes in this sequence: %i', ...
					numel(obj.gui.waveform.gettimes(obj.gui.sequence.tmin, ...
					obj.gui.sequence.tmax))));
			end
			obj.initialize();
		end
	end
	
	methods (Access = 'protected')
		
    function change_waveform_callback(obj)
      indx = get(obj.ui_waveforms, 'Value');
      obj.gui.set_waveform(indx);
    end
    
    
		function export_waveform(obj)
			if isempty(obj.gui.waveform)
				msgbox('Cannot export. No waveform chosen');
				return
			end
			sgnl = obj.gui.main_signal;
			wf = obj.gui.waveform;
			file = obj.gui.file;
			experiment = obj.gui.experiment;
			for k=1:experiment.n
				this_file = experiment.get(k);
				if this_file~=file
					for j=1:this_file.signals.n
						this_signal = this_file.signals.get(j);
						if strcmp(this_signal.tag,sgnl.tag)
							wfs = this_signal.waveforms;
							if wfs.contains(wf)
								msgbox(sprintf('Waveform %s already exists in file %s',wf.tag,this_file.tag));
							elseif sc_contains(wfs.values('tag'),wf.tag)
								msgbox(sprintf('Other waveform with same tag (%s) already exists in file %s',wf.tag,this_file.tag));
							else
								obj.gui.has_unsaved_changes = true;
								this_wf = ScWaveform(this_signal,wf.tag,[]);
								for m=1:wf.n
									threshold = wf.get(m);
									this_wf.add(threshold.create_copy());
								end
								wfs.add(this_wf);
							end
						end
					end
				end
			end
		end
	end
end
