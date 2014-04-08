function ctrl = sc_ctrl(style, string, varargin)

ctrl = uicontrol('style',style,'string',string);
if numel(varargin)
    switch style
        case {'pushbutton', 'popupmenu', 'edit'}
            set(ctrl,'callback',varargin{1});
            varargin = varargin(2:end);
    end
end

if numel(varargin)
    set(ctrl,varargin{:});
end

end