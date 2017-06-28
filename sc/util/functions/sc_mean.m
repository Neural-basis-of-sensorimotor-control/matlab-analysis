function [xmean, xstd, n] = sc_mean(x, varargin)
str = 'default';
dim = 1;
for k=1:length(varargin)
    if isnumeric(varargin{k})
        dim = varargin{k};
    else
        str = varargin{k};
    end
end
nbrofrows = size(x,1);
nbrofcols = size(x,2);
if dim == 1
    xmean = nan(1, nbrofcols);
    xstd = nan(1, nbrofcols);
    n = zeros(1, nbrofcols);
    for k=1:nbrofcols
        pos = isfinite(x(:,k));
        xcol = x(pos,k);
        if  ~isempty(xcol)
            xmean(k) = mean(xcol, str);
            xstd(k) = std(xcol);
            n(k) = length(xcol);
        end
    end
else
    xmean = nan(nbrofrows, 1);
    xstd = nan(nbrofrows, 1);
    n = zeros(nbrofrows, 1);
    for k=1:nbrofrows
        pos = isfinite(x(k,:));
        xrow = x(k,pos);
        if  ~isempty(xrow)
            xmean(k) = mean(xrow, str);
            xstd(k) = std(xrow);
            n(k) = length(xrow);
        end
    end
end
