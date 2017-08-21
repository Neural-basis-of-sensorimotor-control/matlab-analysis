function val = is_double_patch(signal)

val = list_contains(signal.parent.signals.list, 'tag', 'patch') && ...
  list_contains(signal.parent.signals.list, 'tag', 'patch2');

end