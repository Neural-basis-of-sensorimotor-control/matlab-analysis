function eegcvalues_out = modify_eeg(obj,width,threshold,nbr_of_consecutive,filenbr,xlimits)
plot_on = ~nargout || nargin>=6;
if nargin<6, xlimits = [];  end
if isnumeric(filenbr)
  d = load(obj.exp_path);
  experiment = d.obj;
  clear d;
  file = experiment.get(filenbr);
else
  file = filenbr;
end
channels = who('-file',file.filepath);
if ~sc_contains(channels,obj.eegtag)
  fprintf('File ''%s'' does not contain EEG channel ''%s''\n',file.tag,eegtag);
  return
end

eeg = load(file.filepath,'EEG');
eeg = eeg.EEG;
eeg = eeg.values;

eegc = load(file.filepath,'A_EEG');
eegcvalues = eegc.A_EEG.values;

diff_eeg = .5*([0; diff(eeg)] + [diff(eeg); 0]);
diff_eeg(1) = 2*diff_eeg(1); diff_eeg(end) = 2*diff_eeg(end);
b = (1/width)*ones(1,width);
diff_eeg = filter(b,1,diff_eeg);


startind = find(diff_eeg(1:end-1)<threshold & diff_eeg(2:end)>=threshold);
if diff_eeg(1)>=threshold,  startind = [1; startind];   end
stopind = find(diff_eeg(1:end-1)>=threshold & diff_eeg(2:end)<threshold);
if diff_eeg(end)>=threshold, stopind = [stopind; length(diff_eeg)];  end
ind = stopind - startind >= nbr_of_consecutive;
startind = startind(ind);
startind = startind+1;
stopind = stopind(ind);
inds = cell(size(startind));
for k=1:length(startind)
  inds(k) = {(startind(k):stopind(k))'};
end
inds = cell2mat(inds);
inds = inds(:);

ind_not_synchr = eegcvalues<2.5;
temp_val = eegcvalues(ind_not_synchr);
eegcvalues(inds) = 10*ones(size(inds));
eegcvalues(ind_not_synchr) = temp_val;
if nargout
  eegcvalues_out = eegcvalues;
end
if plot_on
  figure(101)
  clf('reset')
  h1=subplot(311);
  plot(eeg)
  title('EEG (panorera / zooma i detta f�ster)')
  h2 = subplot(312);
  plot(eegcvalues);
  title('Erik och Tinas klassificiering');
  ylim([-6 11])
  h3=subplot(313);
  plot(diff_eeg);
  hold on
  plot([0 length(diff_eeg)],threshold*[1 1]);
  title('l�passfiltrerad derivata');
  addlistener(h1,'XLim','PostSet',@(~,~) xlim_listener(h1,h2,h3));
  if ~isempty(xlimits)
    xlim(h1,xlimits);
  end
end
end

function xlim_listener(h1,h2,h3)
xlim(h2,xlim(h1));
xlim(h3,xlim(h1));
end
