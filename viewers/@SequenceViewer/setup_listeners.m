function setup_listeners(obj)

addlistener(obj,'main_channel','PostSet',@(~,~) main_channel_listener(obj));
addlistener(obj,'digital_channels','PreSet',@(~,~) digital_channels_listener_pre(obj));
addlistener(obj,'digital_channels','PostSet',@(~,~) digital_channels_listener_post(obj));
addlistener(obj,'zoom_on','PostSet',@(~,~) zoom_on_listener(obj));
addlistener(obj,'pan_on','PostSet',@(~,~) pan_on_listener(obj));

addlistener(obj,'has_unsaved_changes','PostSet',@(~,~) obj.has_unsaved_changes_listener());
addlistener(obj,'sequence','PostSet',@(~,~) sequence_listener(obj));

addlistener(obj,'main_channel','PostSet',@(~,~) main_channel_listener(obj));

  function main_channel_listener(objh)
    if ~isempty(objh.main_channel)
      addlistener(objh.main_channel,'signal','PostSet',@(~,~) main_signal_listener(objh));
      if ~isempty(objh.main_signal)
        main_signal_listener(objh);
      end
    end
    
    addlistener(objh.main_channel,'ax_pr','PostSet',@(~,~) main_channel_ax_listener(objh));
    
    function main_channel_ax_listener(objh)
      if ~isempty(objh.main_axes)
        z = zoom(objh.main_axes);
        set(z,'ActionPostCallback',@(~,~) xaxis_listener(objh));
        p = pan(objh.plot_window);
        set(p,'ActionPostCallback',@(~,~) xaxis_listener(objh));
      end
      
      function xaxis_listener(objh)
        objh.xlimits = xlim(gca);
      end
    end
  end
  
  function sequence_listener(objh)
    if isempty(objh.sequence)
      objh.rmwf = [];
    else
      if ~isempty(objh.main_signal)
        signal = objh.main_signal;
        rmwfs = signal.get_rmwfs(objh.tmin,objh.tmax);
        if ~rmwfs.n
          objh.rmwf = [];
        else
          if ~isempty(objh.rmwf) && rmwfs.contains(objh.rmwf)
            objh.rmwf = objh.rmwf;
          else
            objh.rmwf = rmwfs.get(1);
          end
        end
      end
    end
  end
  
  function zoom_on_listener(objh)
    if objh.zoom_on
      objh.pan_on = 0;
      zoom(objh.main_axes,'on');
    else
      zoom(objh.main_axes,'off');
    end
  end
  
  function pan_on_listener(objh)
    if objh.pan_on
      objh.zoom_on = 0;
      pan(objh.plot_window,'on');
    else
      pan(objh.plot_window,'off');
    end
  end
  
  
  function digital_channels_listener_pre(objh)
    if ~isempty(objh.digital_channels)
      objh.deletechannel = objh.digital_channels;
    else
      objh.deletechannel = [];
    end
  end
  
  function digital_channels_listener_post(objh)
    if ~isempty(objh.deletechannel) && isobject(objh.deletechannel) && ...
      (isempty(objh.digital_channels) || objh.digital_channels ~= objh.deletechannel)
    delete(objh.deletechannel.ax);
  end
end

function main_signal_listener(objh)
  if ~isempty(objh.main_signal)
    signal = objh.main_signal;
    rmwfs = signal.get_rmwfs(objh.tmin,objh.tmax);
    if ~rmwfs.n
      objh.rmwf = [];
    else
      if ~isempty(objh.rmwf) && rmwfs.contains(objh.rmwf)
        objh.rmwf = objh.rmwf;
      else
        objh.rmwf = rmwfs.get(1);
      end
    end
  end
end

end
