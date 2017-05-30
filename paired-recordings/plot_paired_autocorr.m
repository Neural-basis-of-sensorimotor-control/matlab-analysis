function plot_paired_autocorr(neuron, crosscorr_pretrigger, ...
  crosscorr_posttrigger, crosscorr_kernelwidth, crosscorr_binwidth, ...
  isi_roi, isi_binwidth, isi_max)

stimtimes = get_stim_times(neuron);
stimtimes = cell2mat(stimtimes(:));

[t1, t2, wf1, wf2] = get_neuron_spiketime(neuron);

tag1 = wf1.tag;
tag2 = wf2.tag;

[t1_spont, t1_activated, t1_misc] = separate_times(t1);
[t2_spont, t2_activated, t2_misc] = separate_times(t2);

plot_kernelhist(t1_spont,     t2_spont,     'Spontaneous',    1);
plot_kernelhist(t1_activated, t2_activated, 'Activated',      2);
plot_kernelhist(t1_misc,      t2_misc,      'Miscellaneous',  3);
plot_kernelhist(t1,           t2,           'All',            4);

linkaxes([subplot(3,4,1) subplot(3,4,2) subplot(3,4,3) subplot(3,4,4)]);

plot_isi(t1_spont,     t2, ['Spontaneous ' tag1],   5);
plot_isi(t1_activated, t2, ['Activated ' tag1],     6);
plot_isi(t1_misc,      t2, ['Miscellaneous ' tag1], 7);
plot_isi(t1,           t2, ['All ' tag1],           8);

plot_isi(t2_spont,     t1, ['Spontaneous ' tag2],   9);
plot_isi(t2_activated, t1, ['Activated ' tag2],     10);
plot_isi(t2_misc,      t1, ['Miscellaneous ' tag2], 11);
plot_isi(t2,           t1, ['All ' tag2],           12);

linkaxes([subplot(3,4,5) subplot(3,4,6) subplot(3,4,7) subplot(3,4,8) ...
  subplot(3,4,9) subplot(3,4,10) subplot(3,4,11) subplot(3,4,12)]);


  function plot_kernelhist(trigger1, trigger2, titlestr, subplotindx)
    
    subplot(3, 4, subplotindx)
    cla
    hold on
    
    [~, ~, h_plot] = sc_kernelhist(trigger1, t2, crosscorr_pretrigger, crosscorr_posttrigger, ...
      crosscorr_kernelwidth, crosscorr_binwidth);
    set(h_plot, 'Tag', [tag2 ' (N = ' num2str(length(trigger1)) ')']);
    
    [~, ~, h_plot] = sc_kernelhist(trigger2, t1, crosscorr_pretrigger, crosscorr_posttrigger, ...
      crosscorr_kernelwidth, crosscorr_binwidth);
    set(h_plot, 'Tag', [tag1  ' (N = ' num2str(length(trigger2)) ')']);
    
    title([neuron.tag ': ' titlestr]);
    xlabel('Time [s]');
    ylabel('Frequency [Hz]')
    
    add_legend()
    axis tight
    grid on
  end


  function plot_isi(spikes1, spikes2, titlestr, subplotindx)
    
    subplot(3, 4, subplotindx)
    cla
    hold on
    
    isi = diff(spikes1);
    followed_by_spike2 = arrayfun(@(x) any(spikes2 >= x & spikes2 <= x+isi_roi), ...
      spikes1(1:end-1));
    
    %bintimes = 0:isi_binwidth:isi_max;
    
    isi_followed_by_spike2 = isi(followed_by_spike2);
    isi_followed_by_spike2 = isi_followed_by_spike2(isi_followed_by_spike2 <= isi_max);
    
    [f_isi_followed_by_spike2, bintimes] = sc_kernelfreq(0, ...
      isi_followed_by_spike2, 0, isi_max, crosscorr_kernelwidth, isi_binwidth);
    
%     if ~isempty(isi_followed_by_spike2)
%       f_isi_followed_by_spike2 = histc(isi_followed_by_spike2, bintimes)/...
%         sum(isi_followed_by_spike2);
%     else
%       f_isi_followed_by_spike2 = zeros(size(bintimes));
%     end
    
    plot(bintimes, f_isi_followed_by_spike2/sum(f_isi_followed_by_spike2), 'Tag', ...
      ['Followed by spike N = ' num2str(length(isi_followed_by_spike2))]);
    
    isi_standalone = isi(~followed_by_spike2);
    isi_standalone = isi_standalone(isi_standalone <= isi_max);
    
    [f_isi_standalone, bintimes] = sc_kernelfreq(0, isi_standalone, 0, ...
      isi_max, crosscorr_kernelwidth, isi_binwidth);
        
%     if ~isempty(isi_standalone)  
%       f_isi_standalone = histc(isi_standalone, bintimes)/sum(isi_standalone);
%     else
%       f_isi_standalone = zeros(size(bintimes));
%     end
    
    plot(bintimes, f_isi_standalone/sum(f_isi_standalone), 'Tag', ...
      ['Stand-alone N = ' num2str(length(isi_standalone))]);
    
    title([neuron.tag ': ' titlestr]);
    xlabel('ISI [s]')
    ylabel('Relative distribution')
    add_legend()
    grid on
  end

  function [spont, activated, misc] = separate_times(t)
    
    is_spontaneous = arrayfun(...
      @(x) ~any(stimtimes > x + crosscorr_pretrigger & stimtimes < x + crosscorr_posttrigger), t);
    
    is_activated = arrayfun(...
      @(x) any(stimtimes > x + crosscorr_pretrigger & stimtimes < x), t);
    
    spont     = t(is_spontaneous);
    activated = t(is_activated);
    misc      = t(~is_spontaneous & ~is_activated);
    
  end

end


