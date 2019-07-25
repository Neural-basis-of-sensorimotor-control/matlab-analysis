clear all

N = 10.^(3:6);
fprintf(['Running time tests.\n' ...
  'If it takes more than 30-ish seconds, feel free to abort by pressing CTRL-C\n']);
low_cutoff = 15;
high_cutoff = 1e4;
frequency = 1e5;
order  = 4;

for i=1:length(N)
  x = rand(N(i), 1);
  tic
  v = bandpass(x, [low_cutoff high_cutoff], frequency);
  %[b,a] = butter(order, [low_cutoff high_cutoff]/(frequency/2), 'bandpass');
  %v = filter(b, a, x);
  fprintf('Time elapsed for n = %d: %g seconds\n', N(i), toc);
end