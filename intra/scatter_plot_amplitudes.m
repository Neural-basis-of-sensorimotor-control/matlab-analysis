function scatter_plot_amplitudes(neuron_indx)
%Automatic PSP detection

neuron = get_intra_neurons(neuron_indx);

signal = sc_load_signal(neuron);
signal.parent.tag

waveforms = signal.waveforms;
amplitudes = signal.amplitudes;

xpsps = [];

for i=1:waveforms.n
	
	waveform = waveforms.get(i);
	
	if startswithi(waveform.tag, 'EPSP') || startswithi(waveform.tag, 'IPSP')
		xpsps = add_to_array(xpsps, waveform);
	end
end

figure(10*neuron_indx + 3)
clf
hold on
set(gcf, 'FileName', [neuron.file_str '_scatter.png']);
set(gcf, 'Position', [0 0 1000 1000])

for i=1:amplitudes.n
	
	amplitude = amplitudes.get(i);
	
	rise = amplitude.height;
	width = amplitude.width;
	
	if ~isempty(rise)
		plot(width, rise, '.');
	end
end

%str = amplitudes.values('tag');
%legend_str = str(~sc_amplitude_is_empty(amplitudes.list));

%legend(legend_str);

colors = varycolor(length(xpsps));

for i=1:length(xpsps)
	xpsp = xpsps(i);
	
	for j=1:xpsp.n
		template = xpsp.get(j);
		marker = get_plot_markers(j+1);
		
		x = template.position_offset*signal.dt;
		y = template.v_offset;
		upper_tol = template.upper_tolerance;
		lower_tol = template.lower_tolerance;
		
		[x, ind] = sort(x);
		y = y(ind);
		upper_tol = upper_tol(ind);
		lower_tol = lower_tol(ind);
		
		plot(x, y + upper_tol, marker, 'Color', colors(i,:), ...
			'LineStyle', '-', 'LineWidth', 2);%, 'MarkerSize', 24);
		plot(x, y + lower_tol, marker, 'Color', colors(i,:), ...
			'LineStyle', '-', 'LineWidth', 2);%, 'MarkerSize', 24);
	end
end

grid on