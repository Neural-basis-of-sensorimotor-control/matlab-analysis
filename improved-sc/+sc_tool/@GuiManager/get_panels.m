function [titles, components] = get_panels()

titles = {'Reset', 'Experiment'};

components = {
  {
  {'pushbutton', [], 'Update', [], @(x, ~, ~) x.update()}
  {}
  {'text', 'm_file', @(x) x.help_text, 2,  @st_help_txt, sc_tool.UiControl.default_width, 2*sc_tool.UiControl.default_height}
  {}
  }
  
  {{'text', [], 'Experiment'}
  {'text', 'm_experiment', @(x) x.experiment.save_name}
  {}
  {'text', [], 'File'}
  {'popupmenu', 'm_file', @(x) x.experiment.list, @(x) x.file,  @st_file}
  {}
  }
  };

end