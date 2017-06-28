classdef SubplotChannel < handle

  methods (Abstract)
    plot_channel(obj)
  end

  properties (Abstract)
    subplot_index
  end

  properties
    gui
  end

  properties (Dependent)
    ax
  end

  properties (SetAccess = 'private')
    ax_pr
  end

  methods

    function obj = SubplotChannel(gui)
      obj.gui = gui;
    end

    function update(obj)
      amplitude = obj.gui.amplitude;

      if isempty(amplitude)
        cla(obj.ax);
        return
      end

      set(obj.ax, 'Color', 'k');
      set(obj.ax, 'XColor', 'w');
      set(obj.ax, 'YColor', 'w');
      set(obj.ax, 'GridColor', 'w');
      grid(obj.ax, 'on');

      obj.plot_channel();

    end

    function val = get.ax(obj)
      if isempty(obj.ax_pr) || ~ishandle(obj.ax_pr)
        obj.ax_pr = subplot(1, 2, obj.subplot_index, 'Parent', obj.gui.histogram_window);
      end

      val = obj.ax_pr;
    end
  end
end
