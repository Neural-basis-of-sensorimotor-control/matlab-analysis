function reset_counter(tag, reset_value)

import sc_counter.*

global SC_COUNTER

if nargin < 1
  tag = [];
end

if nargin < 2
  reset_value = 0;
end

if isempty(SC_COUNTER)
  SC_COUNTER = Counter();
end

SC_COUNTER.reset_counter(tag, reset_value);

end