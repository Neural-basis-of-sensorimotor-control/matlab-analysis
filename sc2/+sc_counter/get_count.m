function val = get_count(tag)

import sc_counter.*

global SC_COUNTER

if nargin < 1
  tag = [];
end

if isempty(SC_COUNTER)
  SC_COUNTER = Counter();
else
  val = SC_COUNTER.get_count(tag);
end

end