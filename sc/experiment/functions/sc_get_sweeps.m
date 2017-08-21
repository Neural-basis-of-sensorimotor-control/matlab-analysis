function [sweeps, time] = sc_get_sweeps(v, tmin, triggertimes, pretrigger, ...
  posttrigger, dt)

input_is_logical = islogical(v);

sweeppos = (round(pretrigger/dt):round(posttrigger/dt))';
time = sweeppos*dt;

if tmin>0
  warning('tmin > 0 in sc_get_sweeps')
end

if isempty(triggertimes)
  sweeps = [];
  return
end

if size(triggertimes,2)==1
  triggertimes = triggertimes';
end

triggerpos = round((triggertimes-tmin)/dt)+1;
pos = bsxfun(@plus,triggerpos,sweeppos);

min_pos = min(pos(:));
if min_pos<1
  v = [zeros(abs(min_pos)+1,1); v];
  pos = pos + abs(min_pos)+1;
end
max_pos = max(pos(:));
if max_pos>numel(v)
  v = [v; zeros(abs(max_pos)-numel(v),1)];
end
sweeps = v(pos);

if input_is_logical
	sweeps = logical(sweeps);
end

% 
% time = (pretrigger:dt:posttrigger)';
% time = time(1:end-1);
% sweeps = nan(numel(time),numel(triggertimes));
% for i=1:numel(triggertimes)
%     pos = t>=triggertimes(i)+pretrigger & t<triggertimes(i)+posttrigger;
%     if nnz(pos)>numel(time)
%         pos = find(pos);
%         pos = pos(1:numel(time));
%     end
%     sweeps(:,i) = v(pos);
%     if ~mod(i,10)
%         fprintf('%i out of %i\n',i,numel(triggertimes));
%     end
% end
% 
end
