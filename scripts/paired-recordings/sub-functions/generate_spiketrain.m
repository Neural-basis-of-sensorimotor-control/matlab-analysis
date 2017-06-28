function spiketrain = generate_spiketrain(signal, waveform_tag_1, waveform_tag_2)

waveform1 = signal.waveforms.get(waveform_tag_1);
waveform2 = signal.waveforms.get(waveform_tag_2);

times1 = waveform1.gettimes(0,inf);
times2 = waveform2.gettimes(0,inf);
indx = arrayfun(@is_near, times2);

spiketrain = ScSpikeTrain('fcn', time2(indx));

  function val = is_near(tt)
    
    val = any((times1 + min_latency >= tt) & (times1 + max_latency <= tt));
    
  end

end