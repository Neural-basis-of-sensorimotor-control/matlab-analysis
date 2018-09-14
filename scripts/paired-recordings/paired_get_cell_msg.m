function msg = paired_get_cell_msg(neuron)

msg = '';

switch neuron.file_tag
 
  case 'CNNR0009'
    if is_match('spike2-double', 'spike1-double')
      msg = 'Fig 1B, Fig 3A (5 from top), Fig 4A';
    end
  case 'DGNR0005'
    if is_match('spike3-double', 'spike2-double')
      msg = 'Fig 1C, Fig 3A (3 from top), Fig 4B';
    end
  case 'BKNR0000'
    if is_match('spike3-double', 'spike1-double')
      msg = 'Fig 3A (1 from top)';
    end
  case 'CFNR0003'
    if is_match('spike1-double', 'spike-3')
      msg = 'Fig 3A (2 from top)';
    end
  case 'DBNR0003'
    if is_match('spike1-double', 'spike2-double')
      msg = 'Fig 3A (4 from top)';
    end
end

  function m = is_match(tag1, tag2)
    m = any(strcmp(neuron.template_tag, tag1)) && ...
      any(strcmp(neuron.template_tag, tag2));
  end
end