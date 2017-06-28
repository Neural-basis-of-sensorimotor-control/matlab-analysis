function sc_update_amplitude(amplitude, force_update)
if ~exist('force_update', 'var')
  force_update = false;
end

if length(amplitude)>1
  for i=1:length(amplitude)
    sc_update_amplitude(amplitude(i), force_update);
  end
elseif force_update || isempty(amplitude.is_updated) || ~amplitude.is_updated
  fprintf('Updating amplitude %s\n', amplitude.tag);
  sc_add_pseudo_data_to_amplitude(amplitude);
  amplitude.sc_save(false);
end

  



