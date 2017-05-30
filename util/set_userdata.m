function set_userdata(h, field, value, varargin)

if nargin == 2 && isempty(field)
  h.userdata = [];
  return
end

if isfield(h, 'userdata')
  h.userdata.(field) = value;
elseif any(cellfun(@(x) strcmp(x, 'UserData'), properties(h)))
  
  if ishandle(h)
    udata = get(h, 'UserData');
    udata.(field) = value;
    set(h, 'UserData', udata);
  else
    udata = h.UserData;
    udata.(field) = value;
    h.UserData = udata;
  end
  
elseif any(cellfun(@(x) strcmp(x, 'userdata'), properties(h)))
  
  if ishandle(h)
    udata = get(h, 'userdata');
    udata.(field) = value;
    set(h, 'userdata', udata);
  else
    udata = h.userdata;
    udata.(field) = value;
    h.userdata = udata;
  end
  
else
  error('Could not set userdata property');
end

for i=1:2:length(varargin)
  
  set_userdata(h, varargin{i}, varargin{i+1});

end

end