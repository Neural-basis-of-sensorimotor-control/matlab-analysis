%function nc = rat_neocortex
clear

removeartifacts = true;
eegopt = 'no_rising';

remove_stims_struct(8).remove = [3 6 7 8 12 13 15 17 18 21 25 26 29 31 32 35 36 37 38];
remove_stims_struct(8).label = 'flat sa';
remove_stims_struct(1).remove =  [2 5 10 14 17 20 22 24 25 32 33 35 36 38];
remove_stims_struct(1).label = 'flat fa';
remove_stims_struct(2).remove = [1 2 7 8 9 15 18 22 24 25 26 28 29 30 33 34 35 36 37];
remove_stims_struct(2).label = '2.0 sa';
remove_stims_struct(3).remove = [1 2 3 5 6 10 15 16 17 18 19 20 22 23 25 27 32 33 34];
remove_stims_struct(3).label = '2.0 fa';
remove_stims_struct(4).remove = [2 3 7 8 10 18 24 25 35 37];
remove_stims_struct(4).label = '1.0 sa';
remove_stims_struct(5).remove = [1 2 4 9 10 11 12 13 14 15 16 22 24 25 26 30 31 32 35 37];
remove_stims_struct(5).label = '1.0 fa';
remove_stims_struct(6).remove = [2 4 6 8 14 16 18 22 23 25 26 27 29 31 32 33 36 37];
remove_stims_struct(6).label = '0.5 sa';
remove_stims_struct(7).remove = [1 2 8 9 11 12 14 15 20 24 28 29 35 36 37 38];
remove_stims_struct(7).label = '0.5 fa';

fname = 'D:\MATLAB\sc_mat filer\BPNR_sc.mat';
filenbr = 1;
pretrigger = -1e5;
posttrigger = 1e4;
dd = load(fname);
experiment = dd.obj;


file = experiment.get(filenbr);
signal = file.signals.get('tag','patch');
sequence = file.get('tag','proto');
v = signal.sc_loadsignal();
v = signal.filter.raw_filt(v);
v = signal.filter.artifact_removal(v,sequence.tmin,sequence.tmax);
v = signal.filter.remove_waveforms(v,sequence.tmin,sequence.tmax);

spikes1 = signal.waveforms.get(1).gettimes(sequence.tmin,sequence.tmax);
spikes2 = signal.waveforms.get(2).gettimes(sequence.tmin,sequence.tmax);
triggerparents = file.gettriggerparents(0,inf);
triggerparent = triggerparents.get('tag','TextMark');
triggers = file.gettriggers(sequence.tmin,sequence.tmax);
electrode_stimtimes = cell(10,1);
for k=1:length(electrode_stimtimes)
    tag = sprintf('V%i',k);
    if triggers.has('tag',tag)
        stim = triggers.get('tag',tag);
        electrode_stimtimes(k) = {stim.gettimes(sequence.tmin,sequence.tmax)};
    end
end
nc = NcCell;
% figure(101)
% clf
% set(gcf,'Color',[1 1 1]);
% figure(102)
% clf
% set(gcf,'Color',[1 1 1]);
% figure(103)
% clf
% set(gcf,'Color',[1 1 1]);
% figure(104)
% clf
% set(gcf,'Color',[1 1 1]);
for k=1:length(remove_stims_struct)
    trigger = triggerparent.triggers.get('tag',remove_stims_struct(k).label);
    triggertimes = trigger.gettimes(sequence.tmin,sequence.tmax);
%     figure(101)
%     sc_square_subplot(length(remove_stims_struct),k);
%     sc_perihist(triggertimes,spikes1,-1e-1,1e-1,1e-3);
%     title(remove_stims_struct(k).label);
%     figure(102)
%     sc_square_subplot(length(remove_stims_struct),k);
%     sc_kernelhist(triggertimes,spikes1,-1e-1,1e-1,1e-3,'bandwidth',5e-4);
%     title(remove_stims_struct(k).label);
%     
%     figure(103)
%     sc_square_subplot(length(remove_stims_struct),k);
%     sc_perihist(triggertimes,spikes2,-1e-1,1e-1,1e-3);
%     title(remove_stims_struct(k).label);
%     figure(104)
%     sc_square_subplot(length(remove_stims_struct),k);
%     sc_kernelhist(triggertimes,spikes2,-1e-1,1e-1,1e-3,'bandwidth',5e-4);
%     title(remove_stims_struct(k).label);
%     
    type = NcType();
    type.label = remove_stims_struct(k).label;
    artifacts = [];
    for j=1:length(electrode_stimtimes)
        artifacts = [artifacts; sc_perieventtimes(triggertimes,electrode_stimtimes{j},0,posttrigger)];
    end
    type.artifacts = unique(artifacts);
    [sweeps,time] = sc_perieventsweep(v,round(triggertimes/1e-5)+1,pretrigger,posttrigger-1,1e-5);
    vm = nan(length(triggertimes),nnz(time>=0));
    for j=1:size(vm,1)
        vm0 = sweeps(j,time<0);
        vm0 = mean(vm0(end-10:end));
        vm(j,:) = sweeps(j,time>=0) - vm0;%mean(sweeps(j,time<0));
    end
    for j=1:size(vm,1)
        sw = NcSweep();
        sw.v = vm(j,:);
        sw.rising_edge = any(remove_stims_struct(k).remove == j);
        type.add(sw);
    end
    nc.add(type);
end

%nc.plotdata(removeartifacts,eegopt);
% figure(11)
% clf
% nc.binwiseanova(removeartifacts,eegopt);
% figure(12)
% clf
% nc.plotavg(removeartifacts,eegopt);
% figure(13)
% clf
% nc.plotall(removeartifacts,eegopt);
% 

