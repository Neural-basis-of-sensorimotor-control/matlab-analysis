function parse_protocol(obj, protocolfile)

  function ret = end_of_file(line)
    ret = ~isempty(line) && isnumeric(line) && line == -1;
  end

  function ret = start_of_sequence(line)
    ret = ~isempty(line) && strcmp(line,'"Keyboard"');
  end

  function ret = is_comment(line)
    ret = ~isempty(line) && line(1) == '"';
  end

if obj.is_adq_file
  
  fid = fopen(protocolfile);
  line = fgetl(fid);
  
  %Skip until start of trigger times
  while ~end_of_file(line) && (isempty(line) || is_comment(line)) ....
      && ~start_of_sequence(line)
    
    line = fgetl(fid);
    
  end
  
  %Store trigger times
  triggertimes = nan(1000,1);
  n = 0;
  
  while ~end_of_file(line) && ~(isempty(line) || is_comment(line))
    
    n               = n+1;
    triggertimes(n) = str2double(line);
    line            = fgetl(fid);
    
  end
  
  triggertimes = triggertimes(1:n);
  trg_parent_tag = 'Imported';
  trg_tag = 'stim';
  
  if obj.stims.has('tag',trg_parent_tag)
    triggerparent = obj.stims.get('tag',trg_parent_tag);
  else
    triggerparent = ScAdqTriggerParent(trg_parent_tag);
  end
  
  if triggerparent.triggers.has('tag',trg_tag)
    
    msgbox(sprintf('Trigger parent %s already has a trigger with tag %s in file %s. Aborting.',...
      trg_parent_tag, trg_tag, obj.tag));
    return;
    
  end
  
  triggerparent.triggers.add(ScSpikeTrain('trg',triggertimes));
  obj.stims.update_with_item(triggerparent, triggerparent);
  
  %Skip until start of sequence times
  while ~end_of_file(line) && ~start_of_sequence(line)
    line = fgetl(fid);
  end
  
  if ~end_of_file(line) && start_of_sequence(line)
    
    line = fgetl(fid);
    
    %Skip all empty lines
    while ~end_of_file(line) && isempty(line) && ~is_comment(line)
      line = fgetl(fid);
    end
    
    %Add sequences
    sequence = [];
    
    while ~end_of_file(line) && ~isempty(line) && ~is_comment(line)
      
      strcell = regexp(line,'\d+\.\d+','match');
      tmin = str2double(strcell{1});
      strcell = regexp(line,'".\?\?\?"','match');
      tag = strcell{1};
      tag = tag(2);
      
      if obj.has('tag',tag)
        
        msgbox(sprintf('There is already a sequence with tag %s in file %s. Aborting.',...
          tag,obj.tag));
        break;
        
      end
      
      if ~isempty(sequence)
        sequence.tmax = tmin;
      end
      
      sequence = ScSequence(obj,tag,tmin);
      obj.add(sequence);
      line = fgetl(fid);
      
    end
    
    if ~isempty(sequence)
      
      N = cell2mat({sequence.signals.list.N});
      dt = cell2mat({sequence.signals.list.dt});
      sequence.tmax = max((N+1).*dt);
      
    end
    
  end
  
  fclose(fid);
  
else
  
  fid = fopen(protocolfile);
  
  while 1
    
    line = fgetl(fid);
    
    if isnumeric(line) && line == -1
      fclose(fid);
      msgbox(sprintf([...
        'Could not find file '' %s '' in protocol file.                  \n' ...
        '                                                                \n' ...
        'If the protocol file is correct, it is probably due to a known  \n' ...
        'error with ASCII character encoding in the source code.         \n' ...
        'Send an email to hannes.mogensen@med.lu.se to get information on\n' ...
        'how to circumvent the problem.                                  \n'], ...
        obj.tag));
      return
      
    elseif strcmp(line, ['¤¤' obj.tag])
      break;
    end
    
  end
  
  sequence = [];
  
  while 1
    line = fgetl(fid);
    
    if checkForEof(line)
      
      if ~isempty(sequence)
        
        if ~obj.has('tag',sequence.tag)
          obj.add(sequence);
        end
        
        obj.sc_loadsignals();
        
        if sequence.signals.n
          
          N = cell2mat({sequence.signals.list.N});
          dt = cell2mat({sequence.signals.list.dt});
          sequence.tmax = max((N+1).*dt);
          
        else
          
          sequence.tmax = inf;
          
        end
        
      end
      
      fclose(fid);
      return;
      
    elseif checkForCell(line)
      
      if isempty(obj.comment)
        obj.comment = line(3:end);
      else
        obj.comment = sprintf([obj.comment '\n' line]);
      end
      
    elseif checkForEvent(line)
      
      pos = find(line==' ',2);
      tmin = str2double(line(pos(1):pos(2)));
      tag = line(1);
      
      %Set tmax for previous sequence
      if ~isempty(sequence)
        sequence.tmax = tmin;
      end
      
      if obj.has('tag',tag)
        
        sequence = obj.get('tag',tag);
        
      else
        
        sequence = ScSequence(obj,tag,tmin);
        obj.add(sequence);
        
      end
      
      sequence.comment = line(pos(2)+1:end-3);
      
    elseif ~isempty(line) && ~isempty(sequence)
      
      if isempty(sequence.comment)
        sequence.comment = line;
      else
        sequence.comment = sprintf([sequence.comment '\n' line]);
      end
      
    end
    
  end
  
end

end


%Return true if end of protocol file is reached
function [stopParsing] = checkForEof(line)

stopParsing = ~isempty(line) && ((isnumeric(line) && line == -1) || (length(line) > 2 && strcmp(line(1:2),'ï¿½ï¿½')));

end


%Return true if line contains a new event
function [newEvent] = checkForEvent(line)

newEvent = length(line) > 2 && strcmpi(line(end-1:end),'##');

end


%return true if line contains a new neuron
function [newCell] = checkForCell(line)

newCell = length(line) > 2 && strcmpi(line(1:2),'%%');

end
