function sc_ylims(handles,varargin)
if nargin>=2
    yl = varargin{1};
else
    yl = [inf -inf];
end
for k=1:numel(handles)
    yl_temp = ylim(handles(k));
    yl(1) = min(yl(1),yl_temp(1));
    yl(2) = max(yl(2),yl_temp(2));
end
for k=1:numel(handles)
    ylim(handles(k),yl);
end