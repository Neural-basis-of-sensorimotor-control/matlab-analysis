function [hand, eeg, t] = sync_hand_eeg(hand_params, eeg_params)

% Fix hand time coordinates
unique_val = hand_params.t_hand(1:end-1) ~= hand_params.t_hand(2:end);

t0_hand = rowize(hand_params.t_hand(unique_val));
t0_frame = rowize(hand_params.frame_hand(unique_val));
t0_frame = [ones(size(t0_frame)) t0_frame];

c = t0_frame \ t0_hand;

t_hand = [ones(size(hand_params.frame_hand)) hand_params.frame_hand] * c;

% Align time scales
t0_hand = [rowize(hand_params.t_start_hand); hand_params.t_stop_hand];
t0_hand = [ones(size(t0_hand)) t0_hand];

t0_eeg = [rowize(eeg_params.t_start_eeg); eeg_params.t_stop_eeg];

c = t0_hand \ t0_eeg;

t_hand = [ones(size(t_hand)) t_hand] * c;

valid_data = eeg_params.t_eeg > t_hand(1) & eeg_params.t_eeg < t_hand(end);
t = eeg_params.t_eeg(valid_data); 

hand = interp1(t_hand, hand_params.hand, t);
eeg = eeg_params.eeg(valid_data, :);

end