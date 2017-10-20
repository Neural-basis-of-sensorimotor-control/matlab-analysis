clear all
close all
hold on
n = 1e6;

for i=1:n
  sc_counter.increment([])
  sc_counter.get_count([])
  plot(rand, i, '+')
end