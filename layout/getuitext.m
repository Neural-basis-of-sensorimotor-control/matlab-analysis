function h = getuitext(string, width, varargin)
letterwidth = 6;
if nargin<2,    width = []; end
h = uicontrol('style','text','string', string, 'horizontalalignment','left',...
varargin{:});
minwidth = numel(string)*letterwidth; 
if isempty(width)
    if getwidth(h)<minwidth
        setwidth(h,minwidth);
    end
elseif width==-1
    setwidth(h,minwidth)
else
    setwidth(h,width);
end
