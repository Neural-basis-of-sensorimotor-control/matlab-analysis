clear

reset_fig_indx();
sc_clf_all();

sample_size   = 350;
nbr_of_bins   = [2 6 12 24 48 96 200 2000 20000];
p             = .1;
fcn_bootstrap = @(x, h1, h2, h3) helper2_bootstrap(sample_size, x, p, h1, h2, h3);
arg_in        = nbr_of_bins;
helper_bootstrap(fcn_bootstrap, arg_in);
set(gcf, 'Name', 'Number of bins')

sample_size   = [100 200 400 800 1600 3200 6400];
nbr_of_bins   = 12;
p             = .1;
fcn_bootstrap = @(x, h1, h2, h3) helper2_bootstrap(x, nbr_of_bins, p, h1, h2, h3);
arg_in        = sample_size;
helper_bootstrap(fcn_bootstrap, arg_in);
set(gcf, 'Name', 'Sample size')

sample_size   = 350;
nbr_of_bins   = 12;
p             = [.01 .1 .25];
fcn_bootstrap = @(x, h1, h2, h3) helper2_bootstrap(sample_size, nbr_of_bins, x, h1, h2, h3);
arg_in        = p;
helper_bootstrap(fcn_bootstrap, arg_in);
set(gcf, 'Name', 'Intrinsic activity')

function helper_bootstrap(fcn_bootstrap, arg_in)

incr_fig_indx();
clf

h1 = subplot(221);
title('freq')
hold on
grid on

h2 = subplot(222);
title('stddev')
hold on
grid on

h3 = subplot(223);
title('conf bound')
hold on
grid on

sc_counter.reset_counter();

for i=1:length(arg_in)
  
  sc_counter.increment();
  sc_debug.print(i, length(arg_in));
  
  arrayfun(@(x) fcn_bootstrap(x, h1, h2, h3), arg_in(i)*ones(100, 1));

end

ylim(h1, [0 sc_counter.get_count()+1])
ylim(h2, [0 sc_counter.get_count()+1])
ylim(h3, [0 sc_counter.get_count()+1])

set(h1, 'YTick', 1:length(arg_in), 'YTickLabel', ...
  arrayfun(@num2str, arg_in, 'UniformOutput', false));
set(h2, 'YTick', 1:length(arg_in), 'YTickLabel', ...
  arrayfun(@num2str, arg_in, 'UniformOutput', false));
set(h3, 'YTick', 1:length(arg_in), 'YTickLabel', ...
  arrayfun(@num2str, arg_in, 'UniformOutput', false));

end


function helper2_bootstrap(sample_size, nbr_of_bins, p, h1, h2, h3)

x           = rand(sample_size, nbr_of_bins) < p;
mean_freq   = sum(x)/sample_size;
std_freq    = std(mean_freq);
alpha       = tinv(1-.05, sample_size-1);
conf_freq   = alpha*std_freq/sqrt(sample_size);

axes(h1(end))
plot(mean_freq, sc_counter.get_count()*ones(size(mean_freq)), '+', 'Tag', ...
  num2str(sample_size))

axes(h2(end))
plot(std_freq, sc_counter.get_count(), '+', 'Tag', ...
  num2str(sample_size))

axes(h3(end))
plot(conf_freq, sc_counter.get_count(), '+', 'Tag', ...
  num2str(sample_size))

end