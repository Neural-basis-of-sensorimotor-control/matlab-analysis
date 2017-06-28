function file = get_file_recursive(start_dir, pattern)

file = cell(1000,1);
counter = 0;

for i=1:10
  
  s = rdir([start_dir pattern]);
  
  tmp_file = {s.name};
  
  for j=1:length(tmp_file)
    
    counter = counter + 1;
    file(counter) = tmp_file(j);
    
  end
  
  start_dir = [start_dir '*' filesep]; %#ok<AGROW>
  
end

file = file(1:counter);

end