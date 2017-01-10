function val = startswithi(str, start)

if iscell(str)
  val = cellfun(@check_start, str);
else
  val = check_start(str);
end

  function y = check_start(x1)
    y = length(x1) >= length(start) && strcmpi(x1(1:length(start)), start);
  end

end