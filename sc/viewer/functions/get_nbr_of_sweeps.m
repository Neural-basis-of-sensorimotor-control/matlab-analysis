function val = get_nbr_of_sweeps(triggers)

if isa(triggers, 'ScAmplitude')
  val = min(cell2mat(get_values(triggers, @(x) length(x.stimtimes))));
else
  error('Not implemented for object of type %s', class(triggers));
end