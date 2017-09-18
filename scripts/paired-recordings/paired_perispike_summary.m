function paired_perispike_summary(neuron, f1, f2, f3, f4, f5)

if length(neuron) ~= 1
  
  f1 = incr_fig_indx();
  clf
  hold on
  
  f2 = incr_fig_indx();
  clf
  hold on
  
  
  f3 = incr_fig_indx();
  clf
  hold on
  
  f4 = incr_fig_indx();
  clf
  hold on
  
  
  f5 = incr_fig_indx();
  clf
  hold on
  
  vectorize_fcn(@paired_perispike_summary, neuron, f1, f2, f3, f4, f5);
  
  figure(f1)
  add_legend(f1);
  
  xlabel('Latencies [mV]')
  ylabel('Point nbr');
  
  ylim([0 (max(ylim)+1)]);
  grid on
  set(gca, 'YDir', 'reverse');
  
  figure(f1)
  add_legend(f1);
  
  xlabel('Latencies [s]')
  ylabel('Point nbr');
  
  ylim([0 (max(ylim)+1)]);
  grid on
  set(gca, 'YDir', 'reverse');
  
  figure(f2)
  add_legend(f2);
  
  xlabel('point nbr')
  ylabel('frequency');
    
  figure(f3)
  add_legend(f3);
  
  xlabel('point nbr')
  ylabel('frequency');
    
  figure(f4)
  add_legend(f4);
  
  xlabel('point nbr')
  ylabel('frequency');
  
  figure(f5)
  add_legend(f5);
  
  xlabel('point nbr')
  ylabel('frequency');
  
  return
  
end

[x1, ind] = sort(neuron.x{1});
y1 = neuron.y{1}(ind);


[x2, ind] = sort(neuron.x{2});
y2 = neuron.y{2}(ind);

figure(f1)

plot(x1, 1:length(x1), '+', 'tag', neuron.file_tag)
plot(x2, 1:length(x2), '+', 'tag', neuron.file_tag)

figure(f2)

ind = 1:min(3, length(x1));
plot(x1(ind), y1(ind), 'LineStyle', '-', 'Marker', 'o', 'tag', neuron.file_tag)

ind = 1:min(3, length(x2));
plot(x2(ind), y2(ind), 'LineStyle', '-', 'Marker', 'o', 'tag', neuron.file_tag)

figure(f3)

ind = 3:min(5, length(x1));
plot(x1(ind), y1(ind), 'LineStyle', '-', 'Marker', 'o', 'tag', neuron.file_tag)
ind = 3:min(5, length(x2));
plot(x2(ind), y2(ind), 'LineStyle', '-', 'Marker', 'o', 'tag', neuron.file_tag)

figure(f4)

ind = 5:min(7, length(x1));
plot(x1(ind), y1(ind), 'LineStyle', '-', 'Marker', 'o', 'tag', neuron.file_tag)
ind = 5:min(7, length(x2));
plot(x2(ind), y2(ind), 'LineStyle', '-', 'Marker', 'o', 'tag', neuron.file_tag)

figure(f5)

ind = 7:min(9, length(x1));
plot(x1(ind), y1(ind), 'LineStyle', '-', 'Marker', 'o', 'tag', neuron.file_tag)
ind = 7:min(9, length(x2));
plot(x2(ind), y2(ind), 'LineStyle', '-', 'Marker', 'o', 'tag', neuron.file_tag)

end