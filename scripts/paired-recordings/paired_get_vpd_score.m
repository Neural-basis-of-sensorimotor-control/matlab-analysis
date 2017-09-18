function score = paired_get_vpd_score(enc_t1, enc_t2, cost)

score = cell(size(enc_t1));

for i_pattern=1:length(enc_t1)
  
  t1        = enc_t1{i_pattern};
  t2        = enc_t2{i_pattern};
  tmp_score = nan(size(t1));
  
  for i_repetition=1:length(t1)
    
    tmp_score(i_repetition) = sc_vpd(t1{i_repetition}, t2{i_repetition}, cost);
    
  end
  
  score(i_pattern) = {tmp_score};
  
end

end