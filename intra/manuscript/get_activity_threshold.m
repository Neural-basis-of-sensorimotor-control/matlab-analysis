function activity_threshold = get_activity_threshold(signal)

activity_threshold = signal.userdata.avg_spont_activity + ...
  3*signal.userdata.std_spont_activity;

end