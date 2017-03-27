function val = list_folders(varargin)

s = dir(varargin{:});

is_dir = cell2mat(get_values(s, @(x) x.isdir & ~startsWith(x.name,'.')));

s = {s(is_dir).name};

if nargout
  val = s;
else
  for i=1:length(s)
    disp(s{i});
  end
end
