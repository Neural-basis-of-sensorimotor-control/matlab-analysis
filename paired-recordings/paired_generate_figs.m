% Paired recordings:

%1. Plocka ut alla EC spikar i förening med IC signal, plotta IC signalen

data = {
  'HRNR_sc.mat' 'HRNR0000' 'patch'  'ic-spike-p2-1'
  'HRNR_sc.mat' 'HRNR0000' 'patch2' 'ic-spike-p1-1'
  'HPNR_sc.mat' 'HPNR0003' 'patch'  'ic-spike-p2-1'
  'ILNR_sc.mat' 'ILNR0001' 'patch'  'ec-spike-p1-1'
  'IKNR_sc.mat' 'IKNR0000' 'patch'  'ec-spike-p1-1'
  'ICNR_sc.mat' 'ICNR0002' 'patch'  'ec-spike-p1-1'
  'IFNR_sc.mat' 'IFNR0000' 'patch'  'ec-spike-p1-1'
  'IFNR_sc.mat' 'IFNR0002' 'patch'  'ec-spike-p1-1'
  'DJNR_sc.mat' 'DJNR0005' 'patch'  'ic-spike-p2-1'
  'DJNR_sc.mat' 'DJNR0005' 'patch2' 'ec-spike-p2-1'
  'BPNR_sc.mat' 'BPNR0000' 'patch'  'ec-spike-p1-1'
  'BPNR_sc.mat' 'BPNR0001' 'patch'  'ec-spike-p1-1'
  };

neurons = [];

for i=1:size(data, 1)
  
  n = ScNeuron('experiment_filename', data{i, 1}, 'file_tag', data{i, 2}, ...
    'signal_tag', data{i, 3}, 'template_tag', data(i, 4));
  
  neurons = add_to_list(neurons, n);
  
end

pretrigger = -.02;
posttrigger = .5;

cla
hold on

y0 = 10;

for i=1:length(neurons)
  
  fprintf('%d %d\n', i, length(neurons));
  
  n = neurons(i);
  
  signal = sc_load_signal(n);
  v = signal.get_v(true, true, true, true);
  
  trigger = signal.parent.gettriggers(0, inf).get('tag', n.template_tag{1});
  trigger_times = trigger.gettimes(0, inf);
  
  [sweeps, times] = sc_get_sweeps(v, 0, trigger_times, pretrigger, ...
    posttrigger, signal.dt);
  
  y = double(mean(sweeps, 2));
  y = y - min(y);
  
  plot(times, y0 + y, 'Tag', n.file_tag)
  text(min(times), y0, [n.file_tag ', N = ' num2str(size(sweeps, 2))]);
  
  y0 = y0 + max(y) + 5;
  
end

set(gca, 'FontSize', 14)
title('Averaged IC signal for extracellular spike')
xlabel('Time [s]')
grid on
