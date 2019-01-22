function h = spikeViewer(experiment, indx)

recording = experiment.recordings{indx};
signal    = recording.signals{1};

h = hamo.gui.DefineTemplate(signal, gcf);
h.plotSweep();

end