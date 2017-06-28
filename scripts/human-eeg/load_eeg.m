function [eeg_data, t, t_grab, t_start, t_stop] = load_eeg(file_str)

start_tag = 'SEIZ';
stop_tag = 'PICT';
grab_tag = 'SPIK';

m = load(file_str);

fields = fieldnames(m);

ind = cellfun(@(x) ~isempty(regexp(x, 'aDefault_Subject_', 'once')), fields);

if nnz(ind) ~= 1
  error('Could not find field name for EEG data');
end

eeg_data = m.(fields{ind})(1:end-1, :)';

dt = 1/m.samplingRate;

t = (1:(size(eeg_data, 1))) * dt;

tag_marks = m.Marks(1,:);

indx_start = cellfun(@(x) strcmp(x, start_tag), tag_marks);
indx_stop = cellfun(@(x) strcmp(x, stop_tag), tag_marks);
indx_grab = cellfun(@(x) ~strcmp(x, grab_tag), tag_marks);

t_start = t(cell2mat(m.Marks(4, indx_start)));
t_stop = t(cell2mat(m.Marks(4, indx_stop)));
t_grab = t(cell2mat(m.Marks(4, indx_grab)));

end