function val = increment(tag, incr)

import sc_counter.*

global SC_COUNTER

if nargin < 2
  incr = 1;
end

if isempty(SC_COUNTER)
  SC_COUNTER = Counter();
end
  
SC_COUNTER.increment(tag, incr);

if nargout
  val = SC_COUNTER.get_count(tag);
end

end