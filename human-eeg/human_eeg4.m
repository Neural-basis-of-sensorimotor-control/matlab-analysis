clc
clear

fname_save = 'Grepp - Flaska topp merged.mat';
load(fname_save)

eeg = eeg - repmat(mean(eeg), size(eeg, 1), 1);
hand = hand - repmat(mean(hand), size(hand, 1), 1);
%%
nbr_of_eeg_coeffs = 4;
nbr_of_hand_coeffs = 2;

[coeff_eeg, score_eeg, latent_eeg, tsquared_eeg, explained_eeg, mu_eeg] = ...
  pca(eeg);

[coeff_hand, score_hand, latent_hand, tsquared_hand, explained_hand, mu_hand] = ...
  pca(hand);

nbr_of_coefficients_eeg = nnz(explained_eeg > 5);
nbr_of_coefficients_hand = nnz(explained_hand > 5);

input_eeg = score_eeg(:, 1:nbr_of_coefficients_eeg);
input_hand = score_eeg(:, 1:nbr_of_coefficients_hand);



%%
eeg_rev_eng = score_eeg * coeff_eeg';
hand_rev_eng = score_hand * coeff_hand';

eeg_trivial = eeg * eye(size(eeg, 2));
hand_trivial = hand * eye(size(hand, 2));

eeg_channel_indx = 10;
figure(1)
plot(t, eeg(:,eeg_channel_indx), 'b', ...
  t, eeg_rev_eng(:,eeg_channel_indx), 'r--', ...
  t, eeg_trivial(:,eeg_channel_indx), 'c:')

hand_channel_indx = 2;
figure(2)
plot(t, hand(:,hand_channel_indx), 'b', ...
  t, hand_rev_eng(:,hand_channel_indx), 'r--', ...
  t, hand_trivial(:,hand_channel_indx), 'c:')


%pc_eeg = score_eeg(:,1:nbr_of_eeg_coeffs);
%pc_hand = score_hand(:,1:nbr_of_hand_coeffs);

%eeg_channels = 1:10;
%hand_channels = 1:10;

