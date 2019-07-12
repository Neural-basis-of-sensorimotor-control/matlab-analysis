function quickplot(xy, tag, titl, linewidth)

h = plot(xy(:,1), xy(:,2));
if nargin>=2
    h.Tag = tag;
end

if nargin>=3 && not(isnumeric(titl))
    title(titl)
end

if nargin>=4
    h.LineWidth = linewidth;
end

end