function v = filt_artifacts_simple(v, threshold, pretrigger, posttrigger, mode)

width = -pretrigger + posttrigger;

if ~exist('mode', 'var')
  mode = 'maxval';
end

switch mode
  case 'maxval'
    ind = find(v > threshold);
  case 'minval'
    ind = find(v < threshold);
  otherwise
    error('Unknown value of mode: %s', mode)
end

if isempty(ind)
  return
end

dind = [inf; diff(ind)];
ind = ind(dind>1);
ind = ind + pretrigger;
ind(ind<1) = [];

filtind = repmat(ind, 1, width) + repmat(0:(width-1), length(ind), 1);
v0 = v(filtind(:,1));

v(filtind) = repmat(v0, 1, width);

end