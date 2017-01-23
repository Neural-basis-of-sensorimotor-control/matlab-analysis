function [params, t, labels, frames] = load_hand(file_tag)

labels = get_hand_labels();

estimated_nbr_of_lines = 30000;
nbr_of_params = length(labels);

params = nan(estimated_nbr_of_lines, nbr_of_params);
t = nan(estimated_nbr_of_lines, 1);
frames = nan(estimated_nbr_of_lines, 1);

fid = fopen(file_tag);
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
  
  [t(count), params(count, :), frames(count)] = parse_str(line);
end

frames = frames(1:count);
t = t(1:count);
params = params(1:count, :);

fclose(fid);

end

function [t, params, frame] = parse_str(line)

frame = str2double(line{1});
t = str2double(line{2});
params = [parse_position_brackets(line, 8) ...  % palm position
  parse_position(line, 11) ...                  % pitch / roll / yaw
  parse_position_brackets(line, 14) ...         % arm direction
  parse_position_brackets(line, 17) ...         % wrist position
  parse_position_brackets(line, 20) ...         % elbow position
  parse_finger_position(line, 23) ...           % thumb
  parse_finger_position(line, 41) ...           % index finger
  parse_finger_position(line, 59) ...           % middle finger
  parse_finger_position(line, 77) ...           % ring finger
  parse_finger_position(line, 95)];             % pinky

end

function val = parse_position_brackets(line, offset)

val = nan(1, 3);

str = line{offset};
val(1) = str2double(str(2:end));

val(2) = str2double(line{offset+1});

str = line{offset+2};
val(3) = str2double(str(1:end-1));

end

function val = parse_position(line, offset)

val = nan(1, 3);

val(1) = str2double(line{offset});
val(2) = str2double(line{offset+1});
val(3) = str2double(line{offset+2});

end

function val = parse_finger_position(line, offset)

skip = 3;

offset = offset + skip;

nbr_of_joints = 5;
nbr_of_params_per_joint = 3;

val = nan(1, nbr_of_joints * nbr_of_params_per_joint);

for jointindx=1:nbr_of_joints
  indx = (jointindx-1) * nbr_of_params_per_joint + (1:3);
  val(indx) = parse_position_brackets(line, indx(1) + offset - 1);
end

end