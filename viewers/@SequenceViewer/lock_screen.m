function lock_screen(obj,do_lock,msg)
% if do_lock
%     obj.help_text = 'Computing, wait....';
% else
%     obj.help_text = [];
% end
if nargin<3,    msg = [];   end
obj.help_text = msg;

for k=2:obj.panels.n
    obj.panels.get(k).lock_panel(do_lock);
end
drawnow expose
end