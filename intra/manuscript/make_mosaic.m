%Figure 4
%Create mosaic
%TODO: Add star for negative single pulse!

function make_mosaic
close all

evaluation_fcns = {@get_epsp_amplitude
  @get_epsp_width
  @get_onset_latency};

titlestr = {'Amplitude height [single pulse response = 1], ''*'' = negative single pulse'
  'Time to peak [single pulse response = 1]'
  'Latency [single pulse response = 1]'};

for i=1:length(evaluation_fcns)
  make_mosaic_subfct(evaluation_fcns{i}, figure(i));
  title(titlestr{i});
end

end

function make_mosaic_subfct(mosaik_fcn, fig)

neurons = get_intra_neurons();
nbr_of_neurons = length(neurons);
stims_str = get_intra_motifs();
nbr_of_stims = length(stims_str);
v = nan(nbr_of_neurons, nbr_of_stims);

for i=1:nbr_of_neurons
  signal = sc_load_signal(neurons(i));
  
  for j=1:nbr_of_stims
    stim = get_item(signal.amplitudes.cell_list, stims_str{j});
    
    v(i,j) = mosaik_fcn(stim);
  end
end

[x, y] = meshgrid((1:nbr_of_stims) - .5, (1:nbr_of_neurons) - .5);

clf(fig);
h = surface(x, y, v);
add_colormaps(h, [0 1], @gray, @jet, @bone);

set(gca, 'YTick', (1:nbr_of_neurons), ...
  'YTickLabel', get_values(neurons, 'file_str'), ...
  'XTick', (1:nbr_of_stims), ...
  'XTickLabel', stims_str, ...
  'XTickLabelRotation', 270);

end

function val = get_epsp_amplitude(amplitude)

str = strsplit(amplitude.tag, '#');
str = str{2};
ind = str2num(str(2));

try
val = mean(amplitude.height) / ...
  amplitude.parent.userdata.single_pulse_height(ind);
catch
  val = 0;
end
if val > 4
  val = nan;
end

end


function val = get_epsp_width(amplitude)

str = strsplit(amplitude.tag, '#');
str = str{2};
ind = str2num(str(2));

val = mean(amplitude.width) / ...
  amplitude.parent.userdata.single_pulse_width(ind);

end

function val = get_onset_latency(amplitude)

str = strsplit(amplitude.tag, '#');
str = str{2};
ind = str2num(str(2));

val = mean(amplitude.latency) / ...
  amplitude.parent.userdata.single_pulse_latency(ind);

end
