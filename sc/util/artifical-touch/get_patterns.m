function val = get_patterns(indx)

val = {'0.5 fa'
	'0.5 sa'
	'1.0 fa'
	'1.0 sa'
	'1p electrode 1'
	'1p electrode 2'
	'1p electrode 3'
	'1p electrode 4'
	'2.0 fa'
	'2.0 sa'
	'flat fa'
	'flat sa'};

if nargin
  val = val(indx);
end

end