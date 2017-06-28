function flush_human_eeg(show_lines, show_entries)

fid = fopen('Grepp - Flaska topp.txt');

i = 0;
while true
  line = fgetl(fid);
  
  if isnumeric(line) && line == -1
    break
  end
  
  i=i+1;
  
  if ~nargin || any(show_lines == i)
    
    if nargin<2
      fprintf('line %d\n', i);
      fprintf('%s\n', line);
      
    else
      line = strsplit(line, '\t');
      
      for j=1:length(line)
        
        if any(j == show_entries)
          fprintf('<%d> %s\t', j, line{j})
        end
        
      end
      
      fprintf('\n');
    end
  end
end

fclose(fid);