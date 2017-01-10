function hand_coord = load_hand_coord(file_str)
%'Grepp - Flaska topp.txt'

fid = fopen(file_str);

hand_coord(30000, 1) = HandCoord();
count = 0;

while true
  line = fgetl(fid);
  
  if (isnumeric(line) && line == -1)
    break
  end
  
  line = strsplit(line, '\t');
  
  if length(line) ~= 112
    break
  end
  
  count = count + 1
  
  hand_coord(count) = HandCoord.parse_str(line);
end

hand_coord = hand_coord(1:count);

fclose(fid);


end
