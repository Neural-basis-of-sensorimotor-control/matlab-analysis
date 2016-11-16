%Figure 4
%Create mosaic

function make_mosaic

evaluation_fcns = {@get_epsp_amplitude
  @get_epsp_width
  @get_onset_latency};

for i=1:length(evaluation_fcns)
  make_mosaic_subfct(evaluation_fcns{i}, figure(i));
end

end

function make_mosaic_subfct(mosaik_fcn, fig)

neurons = get_intra_neurons(1);
nbr_of_neurons = length(neurons);
stims_str = get_intra_motifs();
nbr_of_stims = length(stims_str);
v = nan(nbr_of_neurons, nbr_of_stims);

for i=1:nbr_of_neurons
  signal = sc_load_signal(neurons(i));
  threshold = 1.2*signal.userdata.spont_activity;
  
  for j=1:nbr_of_stims
    stim = get_item(signal.amplitudes.cell_list, stims_str{j});
    v(i,j) = mosaik_fcn(stim, threshold);
  end
end

[x, y] = meshgrid(1:nbr_of_stims, 1:nbr_of_neurons);

clf(fig)
surface(x, y, v)

end

function val = get_epsp_amplitude(amplitude, threshold)

if amplitude.response_is_significant(threshold)
  val = mean(amplitude.rise_automatic_detection);
else
  val = 0;
end

end

function val = get_epsp_width(amplitude, threshold)

if amplitude.response_is_significant(threshold)
  val = mean(amplitude.rise_automatic_width);
else
  val = 0;
end

end

function val = get_onset_latency(amplitude, threshold)

if amplitude.response_is_significant(threshold)
  val = mean(amplitude.start(~amplitude.is_pseudo));
else
  val = 0;
end

end
