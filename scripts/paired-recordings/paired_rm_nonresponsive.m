function [neurons, responding] = paired_rm_nonresponsive(neurons, kernelwidth, pretrigger)

response_start = 0;
response_stop  = 0.35;
responding = false(size(neurons));

for i=1:length(neurons)
  [t1, t2] = paired_get_neuron_spiketime(neurons(i));
  enc_start_times = paired_get_stim_times(neurons(i), get_patterns(8));
  
  start_times = [];
  for j=1:length(enc_start_times)
    start_times = add_to_list(start_times, enc_start_times{j}); 
  end
  
  responding(i) = paired_has_response(start_times, t1, kernelwidth, pretrigger, response_start, response_stop)  || ...
      paired_has_response(start_times, t2, kernelwidth, pretrigger, response_start, response_stop);
   
%   incr_fig_indx();
%   clf
%   subplot(2,1,1)
%   [f1, bintimes] = sc_kernelhist(start_times, t1, ec_pretrigger, ec_posttrigger, 10*ec_kernelwidth);
%   m1   = mean(f1(bintimes<0));
%   std1 = std(f1(bintimes<0));
%   hold on
%   plot(xlim, m1*[1 1], 'g', xlim, m1+2*std1*[1 1], 'r')
%   grid on
%   xlim([0 0.35])
%   subplot(2,1,2)
%   f2 = sc_kernelhist(start_times, t2, ec_pretrigger, ec_posttrigger, 10*ec_kernelwidth);
%   m2   = mean(f2(bintimes<0));
%   std2 = std(f2(bintimes<0));
%   hold on
%   plot(xlim, m2*[1 1], 'g', xlim, m2+2*std2*[1 1], 'r')
%   grid on
%   xlim([0 0.35])
end
%brwfigs

neurons = neurons(responding);

end

function has_response = paired_has_response(stimtimes, spiketimes, kernelwidth, pretrigger, response_start, response_stop)


posttrigger    = max(abs( [pretrigger response_stop] ));
[f1, bintimes] = sc_kernelfreq(stimtimes, spiketimes, pretrigger, posttrigger, kernelwidth);
m1             = mean(f1(bintimes<0));
std1           = std(f1(bintimes<0));

has_response   = any(f1(bintimes>=response_start & bintimes<=response_stop) > m1 + 2*std1);

end

