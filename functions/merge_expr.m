function merge_expr

[mergefrom_file, mergefrom_dir] = uigetfile('*_sc.mat', 'Select first file');

if isnumeric(mergefrom_file) && mergefrom_file == 0
  return
end

[mergeto_file, mergeto_dir] = uigetfile('*_sc.mat', 'Select second file');
if isnumeric(mergeto_file) && mergeto_file == 0
  return
end

mergefrom_expr = ScExperimentWrapper.load_file(fullfile(mergefrom_dir, mergefrom_file));
mergeto_expr = ScExperimentWrapper.load_file(fullfile(mergeto_dir, mergeto_file));

for i=1:mergefrom_expr.n
  mergefrom_file = mergefrom_expr.get(i);

  if mergeto_expr.has('tag', mergefrom_file.tag)
    mergeto_file = mergeto_expr.get('tag', mergefrom_file.tag);

    merge_files(mergefrom_file, mergeto_file);
  end

end

save_experiment(mergeto_expr, mergeto_expr.abs_save_path, true);
