function [titles, components] = get_panels()

titles      = {};
components  = {};

titles = add_to_list(titles, 'Experiment');

components = add_to_list(components, {
  'text'      'Experiment'                []      []       []
  'text'      @(x) x.experiment.save_name []      []       []
  'text'      'File'                      []      []       []
  'popupmenu' @(x) x.experiment.list @(x) x.file  @st_file 'm_file'
  });


end