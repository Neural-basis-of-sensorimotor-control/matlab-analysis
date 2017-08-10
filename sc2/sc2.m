function h = sc2

h = ScGuiViewer(gcf);

last_experiment = [get_default_experiment_dir() get_last_experiment()];

if isfile(last_experiment)
  h.set_experiment(last_experiment)
end

end