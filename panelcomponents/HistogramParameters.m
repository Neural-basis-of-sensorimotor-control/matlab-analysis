classdef HistogramParameters < PanelComponent
  properties
    ui_hist_type
    ui_pretrigger
    ui_posttrigger
    ui_binwidth
  end

  methods
    function obj = HistogramParameters(panel)
      obj@PanelComponent(panel);
    end

    function populate(obj,mgr)
      mgr.newline(20);
      mgr.add(sc_ctrl('text','Pretrigger'),100);
      obj.ui_pretrigger = mgr.add(sc_ctrl('edit',[],@(~,~) obj.pretrigger_callback()),100);
      mgr.newline(20);
      mgr.add(sc_ctrl('text','Posttrigger'),100);
      obj.ui_posttrigger = mgr.add(sc_ctrl('edit',[],@(~,~) obj.posttrigger_callback()),100);
      mgr.newline(20);
      mgr.add(sc_ctrl('text','Binwidth'),100);
      obj.ui_binwidth = mgr.add(sc_ctrl('edit',[],@(~,~) obj.binwidth_callback()),100);
      mgr.newline(20);
      mgr.add(sc_ctrl('text','Histogram type'),100);
      obj.ui_hist_type = mgr.add(sc_ctrl('popupmenu',[],@(~,~) obj.hist_type_callback(),...
        'Visible','off'),100);
      %             mgr.newline(20);
      %             mgr.add(sc_ctrl('pushbutton','Update',@(~,~) obj.update()),200);
        end

        function initialize(obj)
          if ~isempty(obj.gui.histogram)
            set(obj.ui_pretrigger,'string',obj.gui.histogram.pretrigger);
            set(obj.ui_posttrigger,'string',obj.gui.histogram.posttrigger);
            set(obj.ui_binwidth,'string',obj.gui.histogram.binwidth);
            [enum,str] = enumeration('HistogramType');
            val = find(enum == obj.gui.histogram.hist_type);
            set(obj.ui_hist_type,'string',str,'Value',val,'Visible','on');
          end
        end

        function updated = update(obj)
          if ~isempty(obj.gui.histogram)
            obj.gui.histogram.plotch();
          else
            cla(obj.gui.histogram.ax);
          end
          updated = true;
        end
      end

      methods (Access = 'protected')
        function pretrigger_callback(obj)
          obj.gui.histogram.pretrigger = str2double(get(obj.ui_pretrigger,'string'));
        end
        function posttrigger_callback(obj)
          obj.gui.histogram.posttrigger = str2double(get(obj.ui_posttrigger,'string'));
        end
        function binwidth_callback(obj)
          obj.gui.histogram.binwidth = str2double(get(obj.ui_binwidth,'string'));
        end
        function hist_type_callback(obj)
          obj.gui.lock_screen(true,'Plotting histogram...');
          val = get(obj.ui_hist_type,'value');
          str = get(obj.ui_hist_type,'string');
          type = str{val};
          [enum,str_] = enumeration('HistogramType');
          index = find(cellfun(@(x) strcmp(x,type),str_),1);
          obj.gui.histogram.hist_type = enum(index);
          obj.update();
          obj.gui.lock_screen(false);
        end
      end
    end
