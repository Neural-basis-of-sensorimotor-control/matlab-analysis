clc
clear

reset_fig_indx();

fname_save = 'Grepp - Flaska topp merged.mat';

load(fname_save)



f1 = incr_fig_indx;

figure(f1)
clf
hold on

y = 0;
for i=1:size(hand,2)
  y = hand(:,i) - min(hand(:,i)) + max(y);
  plot(t, y);
  text(min(t), median(y), labels_hand{i});
end

f1 = incr_fig_indx;

figure(f1)
clf
hold on

y = 0;
for i=1:size(eeg,2)
  y = eeg(:,i) - min(eeg(:,i)) + max(y);
  plot(t, y);
end

