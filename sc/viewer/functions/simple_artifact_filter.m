function v = simple_artifact_filter(v, width_indx, artifact_indx)

if isempty(v) || isempty(artifact_indx)
  return
end

blank_area_indx = bsxfun(@plus, artifact_indx', (1:width_indx)');

dv = (v(artifact_indx+width_indx) - v(artifact_indx))'/width_indx;
v0 = v(artifact_indx)';
blank_area_values = repmat(v0, width_indx, 1) + bsxfun(@times, dv, (1:width_indx)');

v(blank_area_indx) = blank_area_values;

end