classdef NcCell < ObjectList & NcParent
  methods
    function add(obj,item)
      add@ObjectList(obj,item);
      item.parent = obj;
    end
    function ret = time(obj)
      if ~obj.N
        ret = [];
      else
        ret = (0:(obj.N-1))*obj.dt;
      end
    end
    function ret = time_binned(obj)
      ret = ((0:floor((obj.N-1))/obj.binwidth)+.5)*obj.binwidth*obj.dt;
    end
    function ret = N(obj)
      ret = 0;
      for k=1:obj.n
        if obj.get(k).n && obj.get(k).N
          ret = obj.get(k).N;
          break;
        end
      end
    end
    function ret = label_binned(obj,eegopt)
      ret = {};
      ind = 0;
      for k=1:obj.n
        child = obj.get(k);
        label_binned = child.label_binned(eegopt);
        inds = ind + (1:length(label_binned));
        ret(inds) = label_binned;
        ind = inds(end);
      end
    end

    function plotdata(obj,removeartifacts,eegopt)
      for k=1:obj.n
        figure(k)
        clf
        obj.get(k).plotdata(removeartifacts,eegopt);
        set(gcf,'Color',[1 1 1])
        set(gcf,'Name',obj.get(k).label);
      end
    end
    function plotall(obj,removeartifacts,eegopt)
      clf
      for k=1:obj.n
        sc_square_subplot(obj.n,k)
        cla
        nn = obj.get(k).plotall(removeartifacts,eegopt);
        set(gca,'FontSize',14)
        axis tight
        title(sprintf('%s (N = %i)',obj.get(k).label,nn));
      end
      set(gcf,'Color',[1 1 1])
    end
    function plotavg(obj,removeartifacts,eegopt)
      clf
      hold on
      for k=1:obj.n
        obj.get(k).plotavg(removeartifacts,eegopt);
      end
      axis tight
      legend(obj.vals('label'));
      set(gcf,'Color',[1 1 1])
      set(gca,'FontSize',14)
      title('Average membrane potential')
      xlabel('Time [s]');
      ylabel('Voltage [mV]')
    end
    function binwiseanova(obj,removeartifacts,eegopt)
      switch eegopt
        case 'all'
          keepsweeps = true(size(obj.rising_edge));
        case 'rising'
          keepsweeps = obj.rising_edge;
        case 'no_rising'
          keepsweeps = ~obj.rising_edge;
        otherwise
          error('Uknown option: %s\n',eegopt);
        end
        if ~removeartifacts
          keeptimes = true(size(obj.time_binned));
        else
          keeptimes = ~any(cell2mat(obj.vals('artifacts_binned')'));
        end
        time_binned = obj.time_binned;
        p = nan(size(time_binned(keeptimes)));
        v_binned = obj.v_binned(keeptimes,keepsweeps);
        label_binned = obj.label_binned(eegopt);
        for k=1:length(p)
          p(k) = anova1(v_binned(k,:),label_binned,'off');
        end
        semilogy(1e3*time_binned(keeptimes),p,'s');
        set(gcf,'Color',[1 1 1])
        set(gca,'FontSize',14)
        xlabel('Time(ms)');
        ylabel('p-value');
        title(sprintf('P-value for ANOVA, N = %i',nnz(keepsweeps)));
        yl = ylim;
        ylim([yl(1) 1]);
      end
      function doclassify(obj,removeartifacts,eegopt)
        if ~removeartifacts
          keeptimes = true(size(obj.time_binned));
        else
          keeptimes = ~any(cell2mat(obj.vals('artifacts_binned')'));
        end
        times = obj.time_binned;
        times = times(keeptimes);
        keeptimes = find(keeptimes);
        correct = zeros(size(keeptimes));
        for k=1:length(times)
          fprintf('%i out of %i\n',k,length(times));
          sample = [];
          training = [];
          group = [];
          correct_answer = {};
          for j=1:obj.n
            type = obj.get(j);
            switch eegopt
              case 'all'
                keepsweeps = true(size(type.rising_edge));
              case 'rising'
                keepsweeps = type.rising_edge;
              case 'no_rising'
                keepsweeps = ~type.rising_edge;
              otherwise
                error('Uknown option: %s\n',eegopt);
              end
              v_binned = type.v_binned();
              v_binned = v_binned(keeptimes(1:k),keepsweeps);
              labels = type.label_binned(eegopt);
              n = size(v_binned,2);
              indexes = randperm(n);
              top = ceil(5*n/6);
              training_ind = indexes(1:top);
              sample_ind = indexes(top+1:end);
              if isempty(sample_ind)
                error('No sample set')
              end
              training = [training; v_binned(:,training_ind)'];
              group = [group; labels(training_ind)'];
              sample = [sample; v_binned(:,sample_ind)'];
              correct_answer = [correct_answer; labels(sample_ind)'];
            end
            class = classify(sample,training,group,'quadratic');
            nbr = 0;
            for j=1:length(sample)
              if strcmp(class{j},correct_answer{j})
                nbr = nbr+1;
              end
            end
            correct(k) = nbr/length(sample);
          end
          clf
          plot(1e3*times,100*correct,'Marker','+')
          set(gcf,'Color',[1 1 1])
          set(gca,'FontSize',14)
          xlabel('Time (ms)');
          ylabel('% correct classification')
        end
        function ret = dt(~)
          ret = 1e-5;
        end
        function ret = binwidth(~)
          ret = 1e2;
        end
        function ret = rising_edge(obj)
          ret = cell2mat(obj.vals('rising_edge'));
        end
      end
    end
