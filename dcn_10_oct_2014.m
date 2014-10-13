clc
clear
addpath(genpath('C:\Users\Hannes\Documents\GitHub\matlab-analysis\'))
d = load('2NCP_sc.mat');
experiment = d.obj;
wf = experiment.get(1).signals.get(1).waveforms.get(1);
seq = experiment.get(1).get('tag','-');
t = round(wf.gettimes(seq.tmin,seq.tmax)/1e-5);
v = experiment.get(1).signals.get(1).sc_loadsignal;
clear d
clear experiment
clear seq
%%
pos = (-100:1000)';
[v_sorted, v_median] = sc_remove_artifacts(v,wf.width,t);
plotpos = bsxfun(@plus,t',pos);
figure(1)
clf
hold on
plotv = v(plotpos);
for k=1:size(plotv,2)
    plot(plotv(:,k));
end
time = find(pos==0)+(1:numel(v_median));
plot(time,v_median,'r','LineWidth',2)
figure(2)
clf
hold on
plotv = v_sorted(plotpos);
for k=1:size(plotv,2)
    plot(plotv(:,k));
end


find_median(v,numel(v_median),t,v_sorted);

% vm_curved = spaps(1:numel(v_median),v_median,1e-6);
% vm_curved = fnval(vm_curved,1:numel(v_median));
% thispos = pos >=0 & pos<= numel(v_median)-1; 
% plotv = v(plotpos);
% plotv(thispos,:) = plotv(thispos,:) - repmat(vm_curved',1,numel(t));
% figure(3)
% clf
% hold on
% for k=1:size(plotv,2)
%     plot(plotv(:,k));
% end
% figure(4)
% plot(1:numel(v_median),v_median,1:numel(v_median),vm_curved);
% legend('median','median curved')

%%

