function times = get_spiketime(obj)

data = dlmread(obj.file_path, ',', 1, 0);
times = data(:, obj.read_column);
times = times(isfinite(times) & times ~= 0);

end