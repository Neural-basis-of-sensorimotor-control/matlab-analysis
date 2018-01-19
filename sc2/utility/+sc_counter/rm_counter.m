function rm_counter(tag)

import sc_counter.*

global SC_COUNTER

if isempty(SC_COUNTER)
  SC_COUNTER = Counter();
end

SC_COUNTER.rm_tag(tag);

end