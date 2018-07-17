c = {
  'Text', 'Experiment', [], [], []
  'Text', @(x) x.experiment, [], [], 'experiment'
  'Text', 'File', [], [], []
  'PopupMenu', @(x) x.experiment, x.file, @set_file, 'file'
  'Text', 'Sequence', [], [], []
  'PopupMenu', @(x) x.file, x.sequence, @set_sequence, 'sequence'
  }
