function viewer = sc

close all

viewer = sc_viewer.Viewer();

viewer.set_experiment(ScExperiment.load_experiment('IKNR_sc.mat'));

viewer.show();

end