clc
close all
clear
ax = gca;
addlistener(ax,'BeingDeleted','PreSet',@(~,~) disp('being deleted pre set'));
addlistener(ax,'BeingDeleted','PostSet',@(~,~) disp('being deleted post set'));
set(ax,'DeleteFcn',@(~,~) disp('delete fcn'));