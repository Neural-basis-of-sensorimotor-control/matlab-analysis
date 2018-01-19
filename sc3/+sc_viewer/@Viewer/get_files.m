function files = get_files(obj)

if isempty(obj.experiment)
  files = [];
else
  files = obj.experiment.list;
end

end
