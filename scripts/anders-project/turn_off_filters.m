%turn of all filters
experiment = h.viewer.experiment;

for i=1:experiment.n
    
    file = experiment.get(i);
    signals = file.signals.list;
    
    for j=1:length(signals)
        signals(j).simple_artifact_filter.is_on = false;
    end
end