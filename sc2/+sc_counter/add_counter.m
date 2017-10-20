function add_counter(tag, val)

import sc_counter.*

global SC_COUNTER

if nargin < 2
  val = 0;
end

if isempty(SC_COUNTER)
  SC_COUNTER = Counter();
end

if isempty(tag)
  
  SC_COUNTER.default_counter = val;

elseif ~any(cellfun(@(x) strcmp(x, tag)))
  
  SC_COUNTER.tags     = add_to_list(SC_COUNTER.tags, tag);  
  SC_COUNTER.counters = add_to_list(SC_COUNTER.counters, val);
  
else
  
  error('Tag %s already in use', tag);

end

end