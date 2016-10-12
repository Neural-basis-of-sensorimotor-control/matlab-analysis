classdef HistogramCheckbox < PanelComponent
  properties
    ui_show_histogram
  end

  methods
    function obj = HistogramCheckbox(panel)
      obj@PanelComponent(panel);
    end

    function populate(obj,mgr)
      mgr.newline(20);
      obj.ui_show_histogram = mgr.add(sc_ctrl('checkbox',...
        'Show histogram',@(~,~) obj.show_histogram_callback),...
        200);
      end

      function initialize(obj)
        set(obj.ui_show_histogram,'value',obj.gui.show_histogram);
        obj.hide_all_options_but_enable(~obj.gui.show_histogram);
      end
    end

    methods (Access = 'protected')
      function show_histogram_callback(obj)
        val = get(obj.ui_show_histogram,'value');
        if val
          if isempty(obj.gui.histogram)
            clf(obj.gui.histogram_window);
            obj.gui.histogram = HistogramChannel(obj.gui);
            set(obj.gui.histogram.ax,'Parent',obj.gui.histogram_window);
          end
          obj.panel.initialize_panel();
          obj.panel.update_panel();
        else
          obj.gui.histogram = [];
        end
        obj.hide_all_options_but_enable(~val);
      end
      function hide_all_options_but_enable(obj,do_hide)
        ch=get(obj.panel,'Children');
        if do_hide
          str = 'off';
        else
          str = 'on';
        end
        for k=1:numel(ch)
          set(ch(k),'visible',str);
        end
        set(obj.ui_show_histogram,'visible','on');
      end
    end
  end
