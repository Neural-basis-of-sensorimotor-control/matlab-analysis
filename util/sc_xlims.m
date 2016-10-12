function sc_xlims(handles,varargin)
if nargin>=2
  xl = varargin{1};
else
  xl = [inf -inf];
end
for k=1:numel(handles)
  xl_temp = xlim(handles(k));
  xl(1) = min(xl(1),xl_temp(1));
  xl(2) = max(xl(2),xl_temp(2));
end
for k=1:numel(handles)
  xlim(handles(k),xl);
end
