function activity_threshold = intra_get_activity_threshold(signal)

activity_threshold = signal.userdata.avg_spont_activity + ...
  2*signal.userdata.std_spont_activity;

end