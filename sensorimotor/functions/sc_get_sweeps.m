function [sweeps, time] = sc_get_sweeps(v, tmin, triggertimes, pretrigger, posttrigger, dt)

if isempty(triggertimes)
    sweeps = [];    time = [];    return;
end
if size(triggertimes,2)==1
    triggertimes = triggertimes';
end
triggerpos = round((triggertimes-tmin)/dt)+1;
sweeppos = (round(pretrigger/dt):round(posttrigger/dt))';
pos = bsxfun(@plus,triggerpos,sweeppos);
sweeps = v(pos);

time = sweeppos*dt;

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