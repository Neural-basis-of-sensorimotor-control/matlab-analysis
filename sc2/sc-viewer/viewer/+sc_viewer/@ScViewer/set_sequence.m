function set_sequence(obj, sequence)

if isempty(obj.file)
  obj.sequence = [];
else
  obj.sequence = get_item(obj.file.list, sequence);
end

end