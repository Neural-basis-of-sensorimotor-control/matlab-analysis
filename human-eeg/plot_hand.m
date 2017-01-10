function plot_hand(hand_params, indx)

fingers = {'thumb', 'indexfinger', 'middlefinger', 'ringfinger', 'pinky'};

for i=1:length(indx)
  h = gca;
  
  hold(h, 'on');
  grid(h, 'on');
  
  [x, y, z] = plot_arm(h, hand_params);
  
  for j=1:length(fingers)
    plot_finger(h, [x y z], hand_params(indx(i), :), fingers{j})
  end
  
  view(h, -37.5, 30);
end

end


function [xpalm, ypalm, zpalm] = plot_arm(haxes, params)

labels = get_hand_labels();
joints = {'elbow position', 'wrist position', 'palm position'};

msize = size(joints);

x = nan(msize);
y = nan(msize);
z = nan(msize);

for i=1:length(joints)
  joint = [joints{i} ' x'];
  xind = find(cellfun(@(x) strcmp(x, joint), labels));
  
  if length(xind) ~= 1
    error('Could not find joint %s', joint);
  end
  
  x(i) = params(xind);
  y(i) = params(xind + 1);
  z(i) = params(xind + 2);
end

plot3(haxes, x, y, z);

xpalm = x(end);
ypalm = y(end);
zpalm = z(end);

end

function plot_finger(haxes, palm_pos, params, finger)

labels = get_hand_labels();
joints = {'metacarpal joint', 'proximal joint', 'intermediate joint', 'distal joint', 'fingertip'};

msize = size(joints) + [0 1];

x = nan(msize);
y = nan(msize);
z = nan(msize);

x(1) = palm_pos(1);
y(1) = palm_pos(2);
z(1) = palm_pos(3);

for i=1:length(joints)
  joint = [finger ' ' joints{i} ' x'];
  xind = find(cellfun(@(x) strcmp(x, joint), labels));
  
  if length(xind) ~= 1
    error('Could not find joint %s', joint);
  end
  
  x(i+1) = params(xind);
  y(i+1) = params(xind + 1);
  z(i+1) = params(xind + 2);
end

plot3(haxes, x, y, z);

end
