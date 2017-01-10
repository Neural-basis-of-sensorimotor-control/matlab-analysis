function args = sc_parse_input(varargin)

if ~mod(nargin, 2)
  error('Only uneven nunber of inputs accepted (current number of inputs: %d)', ...
    nargin);
end

input_args = varargin{1};
default_args = varargin(2:end);

args = struct;
for i=1:2:length(default_args)
  args.(default_args{i}) = default_args{i+1};
end

for i=1:2:length(input_args)
  if sc_str_contains(fieldnames(args), input_args{i})
    args.(input_args{i}) = input_args{i+1};
  else
    error('Input arg %s is invalid', input_args{i});
  end
end

end