function sc_addlistener(src,property, callback, tempobj)

listener = addlistener(src, property, 'PostSet', callback);
userdata = get(tempobj, 'userdata');
userdata = [userdata, listener];
set(tempobj, 'DeleteFcn', @(~,~) delete_listener(tempobj), ...
  'userdata', userdata);

  function delete_listener(tempobj)
    
    listeners = get(tempobj, 'userdata');
    
    for i=1:length(listeners)
      delete(listeners(i));
    end
    
  end

end
