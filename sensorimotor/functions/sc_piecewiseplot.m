function plothandles = sc_piecewiseplot(x, y, varargin)
args = varargin;
if ishandle(x)
    h = x;
    x = y;
    y = args{1};
    args = args(2:end);
else
    h = gca;
end

leave_hold_on = ishold(h);
hold(h,'on');

dt = min(diff(x))+median(diff(x));
pieces = find(diff(x)>dt);
if size(x,1) >  1
    pieces = pieces';
end
if ~isempty(x)
    pieces = [1 pieces];
end

if nargout, plothandles = nan(size(pieces));    end
if ~isempty(pieces)
    for k=1:length(pieces)
        tmin = x(pieces(k));
        if k==length(pieces)
            tmax = inf;
        else
            tmax = x(pieces(k+1));
        end
        pos = x>tmin&x<tmax;
%       if nargin>2
            if nargout
                plothandles(k) = plot(h,x(pos),y(pos),args{:});
            else
                plot(h,x(pos),y(pos),args{:});
            end
%         else
%             if nargout
%                 plothandles(k) = plot(h,x(pos),y(pos));
%             else
%                 plot(h,x(pos),y(pos));
%             end
%         end
    end
elseif nargout
    plothandles = [];
end
if ~leave_hold_on
    hold(h,'off');
end
