function lock_screen(obj,do_lock)
if do_lock
    obj.help_text = 'Computing, wait....';
else
    obj.help_text = [];
end
for k=2:obj.panels.n
    obj.panels.get(k).lock_panel(do_lock);
end
drawnow expose
end