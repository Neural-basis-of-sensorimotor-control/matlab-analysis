function val = get_patterns(indx)

val = {'flat sa'
  'flat fa'
  '2.0 sa'
  '2.0 fa'
  '1.0 sa'
  '1.0 fa'
  '0.5 sa'
  '0.5 fa'
  '1p electrode 1'
  '1p electrode 2'
  '1p electrode 3'
  '1p electrode 4'
  };

if nargin
  val = val(indx);
end

end