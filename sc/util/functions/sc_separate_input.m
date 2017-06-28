function varargout = sc_separate_input(s)

props = fieldnames(s);
varargout = cell(size(props));

for i=1:length(props)
  varargout(i) = {s.(props{i})};
end

end