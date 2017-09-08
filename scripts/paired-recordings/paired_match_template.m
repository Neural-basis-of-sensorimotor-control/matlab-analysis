function is_match = paired_match_template(signal, sweeps, sweep_times, t_range, templates)

is_match = false(1, size(sweeps,2));

for i=1:length(templates)
  
  template = signal.triggers.get('tag', templates{i});
  
  for j=1:size(sweeps, 2)
    
    template_times = sweep_times(template.match_v(sweeps(:,j)));
    
    if ~is_match(j)
      
      is_match(j) = any(template_times > t_range(1) & template_times < t_range(2));
      
    end
  end
end

end