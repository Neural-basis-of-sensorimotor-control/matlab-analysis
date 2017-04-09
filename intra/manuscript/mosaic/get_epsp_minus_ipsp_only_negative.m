function [val, neg_normalization] = get_epsp_minus_ipsp_only_negative(amplitude)

[val, neg_normalization] = get_epsp_minus_ipsp(amplitude);

if val > 0
  val = 0;
end

end