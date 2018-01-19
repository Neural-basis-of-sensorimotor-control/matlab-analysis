function sequences = get_sequences(obj)

if isempty(obj.file)
  sequences = [];
else
  sequences = obj.file.list;
end

end
