function val = get_userdata(h, field)

if isfield(h, 'userdata')
  udata = h.userdata;
  
elseif any(cellfun(@(x) strcmp(x, 'UserData'), properties(h)))
  
  if ishandle(h)
    udata = get(h, 'UserData');
  else
    udata = h.UserData;
  end
  
elseif any(cellfun(@(x) strcmp(x, 'userdata'), properties(h)))
  
  if ishandle(h)
    udata = get(h, 'UserData');
  else
    udata = h.userdata;
  end
  
else
  error('No field userdata');
end


if isfield(udata, field)
  val = udata.(field);
else
  val = [];
end

end