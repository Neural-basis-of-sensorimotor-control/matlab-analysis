function hand_coord = parse_str(line)

hand_coord = HandCoord();

hand_coord.frame_id = str2double(line{1});
hand_coord.timestamp = str2double(line{2});
hand_coord.nbr_of_hands = str2double(line{3});
hand_coord.nbr_of_fingers = str2double(line{4});
hand_coord.nbr_of_tools = str2double(line{5});
hand_coord.which_hand = line{6};
hand_coord.id = str2double(line{7});

ind = 8;

[hand_coord.palm_position, ind] = parse_position(line, ind);
[hand_coord.palm_orientation.pitch_deg, hand_coord.palm_orientation.roll_deg, ...
  hand_coord.palm_orientation.yaw_deg, ind] = parse_values(line, ind);
[hand_coord.arm_direction, ind] = parse_position(line, ind);
[hand_coord.wrist_position, ind] = parse_position(line, ind);
[hand_coord.elbow_position, ind] = parse_position(line, ind);

[hand_coord.thumb, ind] = parse_finger_values(line, ind);
[hand_coord.indexf, ind] = parse_finger_values(line, ind);
[hand_coord.middlef, ind] = parse_finger_values(line, ind);
[hand_coord.ringf, ind] = parse_finger_values(line, ind);
[hand_coord.pinkyf] = parse_finger_values(line, ind);

end

function [position, ind] = parse_position(line, ind)

str = line{ind};
position.x = str2double(str(2:end));

position.y = str2double(line{ind+1});

str = line{ind+2};
position.z = str2double(str(1:end-1));

ind = ind + 3;

end

function [val1, val2, val3, ind] = parse_values(line, ind)

val1 = str2double(line{ind});
val2 = str2double(line{ind+1});
val3 = str2double(line{ind+2});
ind = ind + 3;

end

function [finger, ind] = parse_finger_values(line, ind)

[finger.id, finger.length_mm, finger.width_mm, ind] = parse_values(line, ind);
[finger.metacarpal_joint, ind] = parse_position(line, ind);
[finger.proximal_joint, ind] = parse_position(line, ind);
[finger.intermediate_joint, ind] = parse_position(line, ind);
[finger.distal_joint, ind] = parse_position(line, ind);
[finger.fingertip, ind] = parse_position(line, ind);

end