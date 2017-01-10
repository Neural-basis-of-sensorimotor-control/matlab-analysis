%% Human EEG project
% Change in parameters here:
clc
clear

fname_hand = 'Grepp - Flaska topp.txt';
fname_eeg = 'Grepp - Flaska topp.mat';
t_start_hand = [260633379837,  260636611466, 260640016847];
t_stop_hand = 261199634759;
fname_save = 'Grepp - Flaska topp merged.mat';

%% Read file with hand parameters:
% i) Open file in a text editor, replace all commas with dots
% ii) Import file:
[hand, t_hand, labels_hand, frame_hand] = load_hand(fname_hand);

hand_params.hand = hand;
hand_params.t_hand = t_hand;
hand_params.labels_hand = labels_hand;
hand_params.frame_hand = frame_hand;
hand_params.t_start_hand = t_start_hand;
hand_params.t_stop_hand = t_stop_hand;

%% Read file with EEG coordinates:
[eeg, t_eeg, t_grab_eeg, t_start_eeg, t_stop_eeg] = load_eeg(fname_eeg);

eeg_params.eeg = eeg;
eeg_params.t_eeg = t_eeg;
eeg_params.t_grab_eeg = t_grab_eeg;
eeg_params.t_start_eeg = t_start_eeg;
eeg_params.t_stop_eeg = t_stop_eeg;


%% Synchronize data
[hand, eeg, t] = sync_hand_eeg(hand_params, eeg_params);

%% Save the data
save(fname_save)

