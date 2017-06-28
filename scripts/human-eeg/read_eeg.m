clear
fname = 'Alex test 1';
fid = fopen(fname);

count = 0;
while true
  line = fgetl(fid);
  
  if isnumeric(line)
    break
  end
  
  fprintf('<START>%s<END>\n', line);
  count = count + 1;
end

count
fclose(fid);

