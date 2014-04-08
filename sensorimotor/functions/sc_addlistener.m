function sc_addlistener(src,property,callback,temporaryobject)

listener = addlistener(src,property,'PostSet',callback);
userdata = get(temporaryobject,'userdata');
userdata = [userdata, listener];
set(temporaryobject,'DeleteFcn',@delete_listener,'userdata',userdata);

    function delete_listener(~,~)
        listeners = get(temporaryobject,'userdata');
        delete(listeners);
    end
end