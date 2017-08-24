clear
clf

n = 10;

x0 = rand(1, n);
x1 = x0;
x2 = x0;

x1(7) = 2;

X = [x1; x2];
X = X - mean(X(:));

[coeff, score] = pca(X);


subplot(311)
cla
hold on

plot(1:n, X(1,:), 'LineStyle', '-', 'Marker', 'o')
plot(1:n, X(2,:), 'LineStyle', '--', 'Marker', '+')
grid on
legend('Sweep 1', 'Sweep 2')
xlabel('time [ms]')
ylabel('Membrane potential [mV]')
title('Example sweeps');
xlim([0 n+1])

subplot(312)
plot(1:n, coeff, 'LineStyle', '-', 'Marker', '*')
xlim([0 n+1])
ylim([0 1.5])
grid on
xlabel('Dimension')
ylabel('Coefficient');
title('Coefficients of first principal component')

subplot(313)
cla
hold on
plot(1:n, score(1) * coeff', 'LineStyle', '-', 'Marker', 'o')
plot(1:n, score(2) * coeff, 'LineStyle', '--', 'Marker', '+')
grid on
xlim([0 n+1])
xlabel('Dimension')
ylabel('Value')
title('Value of first principal component for example sweeps');
legend('Sweep 1', 'Sweep 2')


