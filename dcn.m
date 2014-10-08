clc
clear
binwidth = 5e-4;%5;
pretrigger = -25e-3;
posttrigger = 25e-3;
bandwidth = 5e-4;
npoints = round((posttrigger-pretrigger)/binwidth);
filterwidth = 10;%000;

times = pretrigger:binwidth:posttrigger;
fnames =  ['1NCP0017';    '1NCP0017';    '1NCP0018';    '1NCP0019'];
chars =   ['$';             ',';          '%';          '!'];
n = size(fnames,1);
d=load('1NCP_sc');
for k=1:n
    file = d.obj.get('tag',fnames(k,:));
    sequence = file.get('tag',chars(k));
    file.sc_loadtimes();
    triggers = sequence.gettriggers(sequence.tmin,sequence.tmax);
    stimtimes = triggers.get('tag','1000').gettimes(sequence.tmin,sequence.tmax);
    spiketimes = triggers.get('tag',['spikes' chars(k)]).perievent(stimtimes,pretrigger,posttrigger);
    freq = histc(spiketimes,times);
    freq = freq/(binwidth*numel(stimtimes));
    freq = freq(1:end-1);
    times = times(1:end-1);
    figure (1)
    sc_square_subplot(n,k)
    plot(times,freq);
    ylim([0 200])
    figure (2)
    sc_square_subplot(n,k)
    bar(times,freq);
    axis tight
    ylim([0 220])
    freq = filter(ones(1,filterwidth)/filterwidth,1,freq);
    figure (3)
    sc_square_subplot(n,k)
    plot(times,freq);
    ylim([0 200])
    figure (4)
    sc_square_subplot(n,k)
    bar(times,freq);
    axis tight
    ylim([0 220])
    figure(5)
    sc_square_subplot(n,k);
    ksdensity(spiketimes,'bandwidth',bandwidth,'npoints',npoints);
    figure(6)
    sc_square_subplot(n,k);
    ksdensity(spiketimes,times,'bandwidth',bandwidth,'npoints',npoints);
end