function str = get_save_name(obj)

if isempty(obj.experiment)
  str = '';
else
  str = obj.experiment.save_name;
end

end
