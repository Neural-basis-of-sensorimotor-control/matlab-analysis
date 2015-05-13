function [v, v_median, filterwidth] = sc_remove_artifacts(v,filterwidth,stimpos)
%offset_compensation_width = 5;
if numel(stimpos) && filterwidth
    interspacing = [diff(stimpos)-1; numel(v)-stimpos(end)];
    interspacing = min(interspacing, numel(v)-stimpos);
    filterinput = bsxfun(@plus,stimpos,(1:filterwidth)-1);
    pos = filterinput - repmat(stimpos,1,filterwidth) <= repmat(interspacing,1,filterwidth);
    
    if any(~pos,1)
        fwidth = find(all(pos,1),1,'last');
        [v,v_median] = sc_remove_artifacts(v,fwidth,stimpos);
        zrs = numel(v_median)+1:filterwidth;
        v_median(zrs) = ones(size(zrs));
        filterwidth = fwidth;
    else
        v_median = nan(1,filterwidth);
        %Todo: check with profiler, speed up if slow
        for k=1:length(v_median)
            useindex = pos(:,k);
            v_median(k) = median(v(filterinput(useindex,k)));
        end
        for k=1:length(v_median)
            useindex = pos(:,k);
            v(filterinput(useindex,k)) = v(filterinput(useindex,k)) - v_median(k);
        end
    end
else
    fprintf('Warning in %s: no filtering.\n',mfilename);
    v_median = [];
end
end
