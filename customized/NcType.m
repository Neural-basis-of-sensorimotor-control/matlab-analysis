classdef NcType < ObjectList & NcChild & NcParent
    properties
        label
        artifacts
    end
    properties (Dependent)
        rising_edge
        artifacts_binned
    end
    methods
        function add(obj,item)
            add@ObjectList(obj,item);
            item.parent = obj;
        end
        function plotdata(obj,removeartifacts,eegopt)
            if ~removeartifacts
                keeptimes = true(size(obj.time_binned));
            else
                keeptimes = ~obj.artifacts_binned;
            end
            hold on
            time_binned = obj.time_binned;
            for k=1:obj.n
                sc_square_subplot(obj.n,k);
                cla
                switch eegopt
                    case 'all'
                        do_plot = true;
                    case 'rising'
                        do_plot = obj.get(k).rising_edge;
                    case 'no_rising'
                        do_plot = ~obj.get(k).rising_edge;
                    otherwise
                        error('Uknown option: %s\n',eegopt);
                end
                if do_plot
                    plot(time_binned(keeptimes),obj.get(k).v_binned(keeptimes),'*',...
                        obj.time,obj.get(k).v);
                end
                set(gca,'FontSize',14)
            end
            axis tight
        end
        function plotavg(obj,removeartifacts,eegopt)
            switch eegopt
                case 'all'
                    keepsweeps = true(size(obj.list));
                case 'rising'
                    keepsweeps = cell2mat(obj.vals('rising_edge'));
                case 'no_rising'
                    keepsweeps = ~cell2mat(obj.vals('rising_edge'));
                otherwise
                    error('Uknown option: %s\n',eegopt);
            end
            if ~removeartifacts
                keeptimes = true(size(obj.time_binned));
            else
                keeptimes = ~obj.artifacts_binned;
            end
            time_binned = obj.time_binned; 
            v_binned = obj.v_binned;
            plot(time_binned(keeptimes),mean(v_binned(keeptimes,keepsweeps),2));
        end
        function nn = plotall(obj,removeartifacts,eegopt)
            switch eegopt
                case 'all'
                    keepsweeps = true(size(obj.list));
                case 'rising'
                    keepsweeps = cell2mat(obj.vals('rising_edge'));
                case 'no_rising'
                    keepsweeps = ~cell2mat(obj.vals('rising_edge'));
                otherwise
                    error('Uknown option: %s\n',eegopt);
            end
             if ~removeartifacts
                keeptimes = true(size(obj.time_binned));
            else
                keeptimes = ~obj.artifacts_binned;
            end
            hold on
            time_binned = obj.time_binned;
            for k=1:obj.n
                v_binned = obj.get(k).v_binned;
                plot(time_binned(keeptimes),v_binned(keeptimes));             
            end
            v_binned = obj.v_binned;
            plot(time_binned(keeptimes),mean(v_binned(keeptimes,keepsweeps),2),'Color','k','LineWidth',2)
            nn = nnz(keepsweeps);
        end
        function  ret = N(obj)
             if ~obj.n
                ret = 0;
            else
                ret = length(obj.list(1).v);
            end
        end
        function ret = label_binned(obj,eegopt)
            switch eegopt
                case 'all'
                    keepsweeps = true(size(obj.list));
                case 'rising'
                    keepsweeps = cell2mat(obj.vals('rising_edge'));
                case 'no_rising'
                    keepsweeps = ~cell2mat(obj.vals('rising_edge'));
                otherwise
                    error('Uknown option: %s\n',eegopt);
            end
            ret = cell(size(obj.list));
            for k=1:length(ret)
                ret(k) = {obj.label};
            end
            ret = ret(keepsweeps);
        end
        function ret = get.artifacts_binned(obj)
            time_binned = obj.time_binned-obj.binwidth*obj.dt*.6;
            ret = false(size(time_binned));
            for k=1:length(obj.artifacts)
                [~,ind] = sc_nearest(time_binned,obj.artifacts(k),'lower');
                ret(ind) = true;
            end
        end
        function ret = get.rising_edge(obj)
            ret = cell2mat(obj.vals('rising_edge'));
        end
    end
end