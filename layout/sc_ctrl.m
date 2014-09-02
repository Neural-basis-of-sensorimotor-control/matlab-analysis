function ctrl = sc_ctrl(style, string, callback, varargin)

if nargin<2
    ctrl = uicontrol('style',style);
elseif nargin<3
    ctrl = uicontrol('style',style,'string',string);
else
    ctrl = uicontrol('style',style,'string',string,'callback',callback,...
        varargin{:});
end

end