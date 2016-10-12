function [sweep,time] = sc_perieventsweep(v,triggerpos,pretrigger,posttrigger,dt)
if size(triggerpos,2)>1
  triggerpos = triggerpos';
end
pos = bsxfun(@plus,triggerpos,pretrigger:posttrigger);
pos(pos<1) = ones(nnz(pos<1),1);
pos(pos>length(v)) = length(v)*ones(nnz(pos>length(v)),1);
sweep = v(pos);
if nargout>=2 && nargin>=5
  time = (pretrigger*dt):dt:(posttrigger*dt);
end
end
