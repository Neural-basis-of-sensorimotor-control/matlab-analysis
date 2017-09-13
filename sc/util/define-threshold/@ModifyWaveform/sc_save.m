function sc_save(obj, varargin)

for i=1:length(obj.thresholds)
  sc_save(obj.thresholds(i), varargin{:});
end

end