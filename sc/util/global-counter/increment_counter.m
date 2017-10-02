function val = increment_counter(incr)

global COUNTER

if ~nargin
  incr = 1;
end

COUNTER = COUNTER + incr;

if nargout
  val = COUNTER;
end

end