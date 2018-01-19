function set_file(obj, file)

if isnumeric(file)
  
  files = obj.get_files();
  file = files(file);
  
end

obj.file = file;

obj.set_sequence(get_set_val(obj.get_sequences(), obj.sequence, 'full'));

end
