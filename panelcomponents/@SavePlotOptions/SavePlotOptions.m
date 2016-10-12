classdef SavePlotOptions < PanelComponent
  properties
    filenbr = 1
    filename
    ui_filenbr
    ui_filename
    ui_savebutton
  end
  methods
    function obj = SavePlotOptions(panel)
      obj@PanelComponent(panel);
      obj.sequence_listener();
      sc_addlistener(obj.gui,'sequence',@(~,~) obj.sequence_listener(),obj.uihandle);
    end
    
    function populate(obj,mgr)
      mgr.newline(20);
      obj.ui_filename = mgr.add(sc_ctrl('edit',[],@(~,~) obj.filename_callback()),150);
      obj.ui_filenbr = mgr.add(sc_ctrl('edit',[],@(~,~) obj.filenbr_callback()),50);
      mgr.newline(20);
      obj.ui_savebutton = mgr.add(sc_ctrl('pushbutton','Save signal to .dat',@(~,~) obj.save_plot_callback()),200);
    end
    function initialize(obj)
      set(obj.ui_filename,'String',obj.filename);
      set(obj.ui_filenbr,'String',obj.filenbr);
    end
  end
  
  methods (Access = 'protected')
    function sequence_listener(obj)
      if ~isempty(obj.gui.sequence)
        obj.filename = sprintf('%s_%s_signal_', obj.gui.file.tag, obj.gui.sequence.tag);
        set(obj.ui_filename,'String',obj.filename);
      end
    end
    
    function save_plot_callback(obj)
      plothandles = get(obj.gui.main_axes,'Children');
      xl = get(obj.gui.main_axes,'xlim');
      m = [];
      for i=1:numel(plothandles)
        if strcmpi(get(plothandles(i),'Type'),'line')
          XData = get(plothandles(i),'XData')';
          YData = get(plothandles(i),'YData')';
          pos = XData>=xl(1) & XData<=xl(2);
          if isempty(m)
            m = nan(nnz(pos),numel(plothandles)+1);
            m(:,1) = XData(pos);
          elseif nnz(pos)~=size(m,1)
            msgbox('Cannot save this type of plot.');
            return;
          end
          m(:,i+1) = YData(pos); %#ok<AGROW>
        end
      end
      m = m(:,all(isfinite(m),1));
      if isempty(m)
        msgbox('Cannot plot this');
        return;
      end
      for k=1:obj.gui.analog_ch.n
        ch = obj.gui.analog_ch.get(k);
        if ch==obj.gui.main_channel
          break;
        end
        axhandle = ch.ax;
        plothandles = get(axhandle,'Children');
        m2 = [];
        for i=1:numel(plothandles)
          if strcmpi(get(plothandles(i),'Type'),'line')
            XData = get(plothandles(i),'XData')';
            YData = get(plothandles(i),'YData')';
            if isempty(m2)
              m2 = nan(nnz(pos),numel(plothandles));
            elseif nnz(pos)~=size(m2,2)
              msgbox('Cannot save this type of plot.');
              return;
            end
            m2(:,i) = interp1(XData,YData,m(:,1)); %#ok<AGROW>
          end
        end
        m2 = m2(:,all(isfinite(m2),1));
        m = [m m2];
      end
      %Convert from s to ms
      m(:,1) = 1e3*m(:,1);
      obj.filename = get(obj.ui_filename,'string');
      obj.filenbr = str2double(get(obj.ui_filenbr,'string'));
      savename = sprintf('%s%.3i.dat',obj.filename, obj.filenbr);
      if exist(savename,'file')==2
        answer = questdlg('File exists already. Overwrite?','Overwrite',...
          'Yes','No','Yes');
        if isempty(answer), answer = 'No';  end
        switch answer
          case 'Yes'
            %do nothing
          case 'No'
            return;
          otherwise
            error(['debugging error: :' answer])
          end
        end
        dlmwrite(savename,m);
        obj.filenbr = obj.filenbr+1;
        set(obj.ui_filenbr,'string',obj.filenbr);
        fprintf('Plot saved\n');
      end
      function filename_callback(obj)
        obj.filename = get(obj.ui_filename,'string');
      end
      function filenbr_callback(obj)
        obj.filenbr = str2double(get(obj.ui_filenbr,'string'));
      end
    end
  end
