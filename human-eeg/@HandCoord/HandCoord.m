classdef HandCoord < handle
  
  properties (Constant)
    finger_labels = {'thumb'
      'indexf'
      'middlef'
      'ringf'
      'pinkyf'}
    
    joint_labels = {'metacarpal_joint'
      'proximal_joint'
      'intermediate_joint'
      'distal_joint'
      'fingertip'}
  end
  
  properties (Dependent)
    coordinates
    finger_coordinates
    
    labels
    joint_labels_full
  end
  
  properties
    frame_id
    timestamp
    nbr_of_hands
    nbr_of_fingers
    nbr_of_tools
    which_hand
    id
    
    palm_position
    palm_orientation
    arm_direction
    wrist_position
    elbow_position
    
    thumb
    indexf
    middlef
    ringf
    pinkyf
  end
  
  methods
    
    function val = get.coordinates(obj)
      val = [obj.palm_position.x
        obj.palm_position.y
        obj.palm_position.z
        obj.palm_orientation.pitch_deg
        obj.palm_orientation.roll_deg
        obj.palm_orientation.yaw_deg
        obj.arm_direction.x
        obj.arm_direction.y
        obj.arm_direction.z
        obj.wrist_position.x
        obj.wrist_position.y
        obj.wrist_position.z
        obj.elbow_position.x
        obj.elbow_position.y
        obj.elbow_position.z
        obj.finger_coordinates
        ];
    end
    
    function val = get.finger_coordinates(obj)
      nbr_of_finger_labels = length(obj.finger_labels);
      nbr_of_joint_labels = length(obj.joint_labels);
      
      val = nan(nbr_of_finger_labels * nbr_of_joint_labels * 3, 1);
      
      for i=1:length(obj.finger_labels)
        for j=1:length(obj.joint_labels)
          xyz = obj.(obj.finger_labels{i}).(obj.joint_labels{j});
          val((j-1)*3 + (i-1)*nbr_of_joint_labels*3 + (1:3)) = [xyz.x xyz.y xyz.z];
        end
      end
    end
    
    function val = get.labels(obj)
      val = [{'obj.palm_position.x'
        'obj.palm_position.y'
        'obj.palm_position.z'
        'obj.palm_orientation.pitch_deg'
        'obj.palm_orientation.roll_deg'
        'obj.palm_orientation.yaw_deg'
        'obj.arm_direction.x'
        'obj.arm_direction.y'
        'obj.arm_direction.z'
        'obj.wrist_position.x'
        'obj.wrist_position.y'
        'obj.wrist_position.z'
        'obj.elbow_position.x'
        'obj.elbow_position.y'
        'obj.elbow_position.z'
        }
      obj.joint_labels_full];
    end
    
    function val = get.joint_labels_full(obj)
      nbr_of_finger_labels = length(obj.finger_labels);
      nbr_of_joint_labels = length(obj.joint_labels);
      
      val = cell(nbr_of_finger_labels * nbr_of_joint_labels * 3, 1);
      
      for i=1:nbr_of_finger_labels
        for j=1:nbr_of_joint_labels
          str = [obj.finger_labels{i} '.' obj.joint_labels{j} '.'];
          
          val((j-1)*3 + (i-1)*nbr_of_joint_labels*3 + 1) = {[str 'x']};
          val((j-1)*3 + (i-1)*nbr_of_joint_labels*3 + 2) = {[str 'y']};
          val((j-1)*3 + (i-1)*nbr_of_joint_labels*3 + 3) = {[str 'z']};
        end
      end
    end
    
  end
  
  methods (Static)
    hand_coord = parse_str(line)
  end
end