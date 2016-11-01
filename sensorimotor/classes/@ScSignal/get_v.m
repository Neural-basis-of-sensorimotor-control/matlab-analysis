function v = get_v(obj, smooth, remove_artifacts, remove_waveforms, ...
  remove_artifacts_simple)

if isstruct(smooth)
  s = smooth;
  smooth = s.smooth;
  remove_artifacts = s.remove_artifacts;
  remove_waveforms = s.remove_waveforms;
  remove_artifacts_simple = s.remove_artifacts_simple;
end

if remove_artifacts_simple
  remove_artifacts = false;
end

v = obj.sc_loadsignal;

if smooth && ~remove_artifacts
  v = obj.filter.raw_filt(v);
elseif remove_artifacts
  v = obj.filter.filt(v, 0, inf);
end

if remove_waveforms
  rmwfs = obj.get_rmwfs(-inf, inf);
  
  for k=1:rmwfs.n
    v = rmwfs.get(k).remove_wf(v, 0);
  end
end

if remove_artifacts_simple
  v = obj.simple_artifact_filter.apply(v);
end

end