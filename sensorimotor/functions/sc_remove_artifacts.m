function v = sc_remove_artifacts(v,filterwidth,stimpos)

interspacing = [diff(stimpos)-1; numel(v)-stimpos(end)];
interspacing = min(interspacing, numel(v)-stimpos);
filterinput = bsxfun(@plus,stimpos,(1:filterwidth)-1);
pos = filterinput - repmat(stimpos,1,filterwidth) <= repmat(interspacing,1,filterwidth);

if any(~all(pos,1))
    filterwidth = find(all(pos,1),1,'last');
    v = sc_remove_artifacts(v,filterwidth,stimpos);
else
    v_median = zeros(1,filterwidth);
    samplesizes = sum(pos,1);
    for k=unique(samplesizes)
        columns = samplesizes == k;
        v_median(samplesizes == k) = median(v(filterinput(1:k,columns)),1);
    end
    [~,medianpos] = find(pos);
    v(filterinput(pos)) = v(filterinput(pos)) - v_median(medianpos)';
end
