function set_file(obj,file)
obj.file = file;
if ~isempty(file)
    obj.file.sc_loadtimes();
end
if ~isempty(file) && file.n
    if isempty(obj.sequence) || ~file.contains(obj.sequence)
            obj.set_sequence(obj.file.get(1));
    end
else
    obj.set_sequence([]);
end
end