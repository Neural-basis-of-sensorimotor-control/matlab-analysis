clc
clear
fnames =  ['1NCP0017';    '1NCP0017';    '1NCP0018';    '1NCP0019'];
chars =   ['$';             ',';          '%';          '!'];
d=load('1NCP_sc');
for k=1:size(fnames,1)
    file = d.obj.get('tag',fnames(k,:));
    sequence = file.get('tag',chars(k));
    file.sc_loadtimes();
    triggers = sequence.gettriggers(sequence.tmin,sequence.tmax);
    spiketimes = triggers.get('tag',['spikes' chars(k)]);
    stimtimes = triggers.get('tag','1000');
end