clear all
N = 10.^(3:6);
fprintf(['Running time tests.\n' ...
  'If it takes more than 30-ish seconds, feel free to abort by pressing CTRL-C\n']);
for i=1:length(N)
  x = rand(N(i), 1);
  tic
  v = bandpass(x, [15 1e4], 1e5);
  fprintf('Time elapsed for n = %d: %g seconds\n', N(i), toc);
end