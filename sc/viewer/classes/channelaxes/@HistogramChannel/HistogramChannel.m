classdef HistogramChannel < GuiAxes
  
  properties
    hist_type = HistogramType.peristim
    pretrigger = -.1
    posttrigger = .1
    binwidth = 1e-2
    rasterplot
  end
  
  methods
    function obj = HistogramChannel(gui)
      obj@GuiAxes(gui);
      setheight(obj.ax, 250);
    end
    
    function clear_data(~), end
    function load_data(~), end
    
    
    function plotch(obj,varargin)
    
      if obj.hist_type ~= HistogramType.raster
        cla(obj.gui.histogram.ax);
      end
      
      if ~isempty(obj.gui.waveform)
      
        switch obj.hist_type
        
          case HistogramType.peristim
            spiketimes = obj.gui.waveform.perievent(obj.gui.triggertimes,...
              obj.pretrigger,obj.posttrigger);
            if ~isempty(spiketimes)
              edges = (obj.pretrigger:obj.binwidth:obj.posttrigger)';
              firing = histc(spiketimes,edges)/(numel(obj.gui.triggertimes) * obj.binwidth);
              bar(obj.gui.histogram.ax,edges,firing,'EdgeColor',[1 0 0]);
              xlabel(obj.gui.histogram.ax,'Time [s]','Color',[1 1 1])
              ylabel(obj.gui.histogram.ax,'Firing [Hz]')
            end
            xlim(obj.gui.histogram.ax,[obj.pretrigger obj.posttrigger]);
            set(obj.gui.histogram.ax,'Color',[0 0 0],'XColor',[1 1 1],'YColor',...
              [1 1 1],'Box','off');
          
          case HistogramType.ISI_pdf
            isi = diff(obj.gui.waveform.gettimes(obj.gui.tmin,obj.gui.tmax));
            if ~isempty(isi)
              edges = (obj.pretrigger:obj.binwidth:obj.posttrigger)';
              isi_pdf = histc(isi,edges)/numel(isi);
              plot(obj.gui.histogram.ax,edges,isi_pdf,'Color',[1 0 0],'LineWidth',4);
              xlabel(obj.gui.histogram.ax,'ISI time [s]')
              ylabel(obj.gui.histogram.ax,'pdf')
              set(obj.gui.histogram.ax,'Color',[0 0 0],'XColor',[1 1 1],'YColor',...
                [1 1 1],'Box','off');
              fprintf('\n-------------------------\n')
              fprintf('ISI mean\t%g s\nISI std dev\t%g s\nISI cv\t\t%g\n',mean(isi),std(isi),std(isi)/mean(isi));
              fprintf('-------------------------\n')
            end
            
          case HistogramType.continuous
            spiketimes = obj.gui.waveform.gettimes(obj.gui.sequence.tmin,obj.gui.sequence.tmax);
            if ~isempty(spiketimes)
              edges = obj.gui.sequence.tmin:obj.binwidth:obj.gui.sequence.tmax;
              firing = histc(spiketimes,edges)/obj.binwidth;
              edges_minutes = (edges-edges(1))/60;
              plot(obj.gui.histogram.ax,edges_minutes,firing,'Color',[1 0 0]);
              xlabel(obj.gui.histogram.ax,'Time [minutes]','Color',[1 1 1])
              ylabel(obj.gui.histogram.ax,'Firing [Hz]')
            end
            set(obj.gui.histogram.ax,'Color',[0 0 0],'XColor',[1 1 1],'YColor',...
              [1 1 1],'Box','off');
          
          case HistogramType.continuous_all_files
            spiketimes = obj.gui.experiment.get_spiketimes(obj.gui.waveform.tag);
            if ~isempty(spiketimes)
              edges = 0:obj.binwidth:max(spiketimes);
              firing = histc(spiketimes,edges)/obj.binwidth;
              edges_minutes = (edges-edges(1))/60;
              plot(obj.gui.histogram.ax,edges_minutes,firing,'Color',[1 0 0]);
              xlabel(obj.gui.histogram.ax,'Time [minutes]','Color',[1 1 1])
              ylabel(obj.gui.histogram.ax,'Firing [Hz]')
            end
            set(obj.gui.histogram.ax,'Color',[0 0 0],'XColor',[1 1 1],'YColor',...
              [1 1 1],'Box','off');
          
          case HistogramType.raster
          
            if isempty(obj.gui.rasterplot_window) || ~ishandle(obj.gui.rasterplot_window)
              obj.gui.rasterplot_window = figure('Tag', SequenceViewer.figure_tag);
              set(obj.gui.rasterplot_window,'Name','Raster plot');
            end
            
            [t,sweep] = obj.gui.waveform.perievent(obj.gui.triggertimes, obj.gui.pretrigger, obj.gui.posttrigger);
            obj.rasterplot = subplot(6,1,1:4,'parent',obj.gui.rasterplot_window);
            plot(obj.rasterplot,t,sweep,'k.','markersize',1,'Color',[0 0 0]);
            set(obj.rasterplot,'YDir','reverse')
            set(obj.rasterplot,'FontSize',14);
            xlabel(obj.rasterplot,'Time [s]')
            ylabel(obj.rasterplot,'Sweep nbr')
            xlim(obj.rasterplot,[obj.gui.pretrigger obj.gui.posttrigger])
            title(obj.rasterplot,'Raster plot');
            histogram_axes = subplot(6,1,5,'parent',obj.gui.rasterplot_window);
            spiketimes = obj.gui.waveform.perievent(obj.gui.triggertimes,obj.gui.pretrigger,obj.gui.posttrigger);
            
            if ~isempty(spiketimes)
              edges = (obj.gui.pretrigger:obj.binwidth:obj.gui.posttrigger)';
              firing = histc(spiketimes,edges)/(numel(obj.gui.triggertimes) * obj.binwidth);
              bar(histogram_axes,edges,firing,'EdgeColor',[1 0 0]);
              xlabel(histogram_axes,'Time [s]')
              ylabel(histogram_axes,'Firing [Hz]')
            end
            
            xlim(histogram_axes,[obj.gui.pretrigger obj.gui.posttrigger])
            title(histogram_axes,'Histogram');
            stimplot = subplot(6,1,6,'parent',obj.gui.rasterplot_window);
            hold(stimplot,'on');
            stims = obj.gui.sequence.stims;
            sweeps = 1:numel(obj.gui.triggertimes);
            height = 0;
            ytick = {};
            
            for i=1:stims.n
              for j=1:stims.get(i).triggers.n
                trg = stims.get(i).triggers.get(j);
                ytick(numel(ytick)+1) = {trg.tag};
                height = height+1;
                plot(stimplot,[obj.gui.pretrigger obj.gui.posttrigger],[height height]);
                times = trg.perievent(obj.gui.triggertimes(sweeps),obj.gui.pretrigger,obj.gui.posttrigger);
                for k=1:numel(times)
                  plot(stimplot,times(k)*ones(2,1),height+[-.5 .5],'LineWidth',2)
                end
              end
            end
            xlabel(stimplot,'Time [s]');
            set(stimplot,'YTick',1:numel(ytick),'YTickLabel',ytick);
            ylabel(stimplot,'Stims');
            ylim(stimplot,[0 (numel(ytick)+1)]);
            title(stimplot,'Stims');
        end
        if obj.hist_type == HistogramType.raster
          figure(obj.gui.rasterplot_window);
        else
          figure(obj.gui.histogram_window)
        end
      end
    end
  end
end
