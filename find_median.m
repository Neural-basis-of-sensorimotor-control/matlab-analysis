function v_median = find_median(v,filterwidth,stimpos,v_initial)
pos = (-100:1000)';
plotpos = bsxfun(@plus,stimpos',pos);
[~,v_median] = sc_remove_artifacts(v,filterwidth,stimpos);
ranges = bsxfun(@plus,stimpos,round([-filterwidth/10 filterwidth/10]));
ranges(ranges<1) = 1*ones(size(find(ranges<1)));
ranges(ranges>numel(v)-numel(v_median)) = (numel(v)-numel(v_median))*ones(size(find(ranges>numel(v)-numel(v_median))));
overlap = ranges(1:end-1,2)>=ranges(2:end,1);
ranges(overlap,2) = floor((stimpos([overlap; false])+stimpos([false; overlap]))/2);
ranges([false; overlap],1) = ranges([overlap; false],2)+1;
figure(10)
clf
hold on
plot(v_median)
for kk=1:3
    for k=1:numel(stimpos)
        stimpos(k) = find_min(ranges(k,:));
    end
    figure(kk+2)
    [vplot,v_median] = sc_remove_artifacts(v,filterwidth,stimpos);
    clf
    hold on
    plotv = vplot(plotpos);
    for k=1:size(plotv,2)
        plot(plotv(:,k));
    end
    vplot = vplot - v_initial;
    figure(10+kk)
    clf
    hold on
    plotv = vplot(plotpos);
    for k=1:size(plotv,2)
        plot(plotv(:,k));
    end
    figure(10)
    plot(v_median)%+kk)
end

    function minpos = find_min(minmax)
        ressqrd = nan(range(minmax)+1,1);
        indices = minmax(1):minmax(2);
        for i=1:numel(indices)
            residual = v(indices(i): (indices(i)+filterwidth-1) )' - v(indices(i)) - v_median;
            ressqrd(i) = sum(residual.^2);
        end
        [~,ind] = min(ressqrd);
        minpos = indices(ind);
    end

end

%
% for j=1:5
%     for k=1:numel(stimpos)
%         stimpos(k) = find_tweak(stimpos(k),ranges(k,1),ranges(k,2));
%     end
%     [vplot,v_median] = sc_remove_artifacts(v,filterwidth,stimpos);
%     figure(3+j)
%     clf
%     hold on
%     plotv = vplot(plotpos);
%     for k=1:size(plotv,2)
%         plot(plotv(:,k));
%     end
% end
%
%     function tweak = find_tweak(stim,tmin,tmax)
%         tweak = round(lsqnonlin(@cost_fcn,stim,tmin,tmax));
%         if tweak~=stim
%             fprintf('at least once!\n')
%         end
%         function cost = cost_fcn(stim)
%             %stim = round(stim);
%             cost = double(sqrt(sum((v(stim+(0:(numel(v_median)-1)))-v_median').^2)));
%         end
%     end
% end