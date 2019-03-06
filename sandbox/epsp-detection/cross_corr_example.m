n = 1000000;
m = 1000;
dt = 1e-5;
n2 = 10;
spike = 20*sin((1:m)'/m * 2*pi);%3*rand(m, 1);%
fakeSpike1 = 10*sin((1:m)'/m * 4*pi);
fakeSpike2 = 70*sin((1:m)'/m * 2*pi);
v = randn(n, 1);
k = 2;
real_spike_indx = randi(n-m, n2, 1);
for i=1:n2
    localMax = real_spike_indx(i):(real_spike_indx(i)+m-1);
    v(localMax) = v(localMax) + spike;
end
indx2 = randi(n-m, n2);
for i=1:n2
    localMax = indx2(i):(indx2(i)+m-1);
    v(localMax) = v(localMax) + fakeSpike1;
end
indx3 = randi(n-m, n2);
for i=1:n2
    localMax = indx3(i):(indx3(i)+m-1);
    v(localMax) = v(localMax) + fakeSpike2;
end

movingAvgNormalization = movmean(sqrt(v.^2), m);
spikeSumNormalization = sum(spike.^2)*ones(size(v));

vConvoluted = conv(v, spike(length(spike):-1:1), 'same');
t = (1:n)'*dt;

fig1 = figure(1)
clf
subplot(411)
title('raw data')
hold on
grid on
plot(t, v)
for i=1:n2
    plot((real_spike_indx(i)-1+(1:length(spike))')*dt, spike, 'r', 'Tag', 'Real spike')
end
for i=1:n2
    plot((indx2(i)-1+(1:length(fakeSpike1))')*dt, fakeSpike1, 'g', 'Tag', 'Fake spike 1')
end
for i=1:n2
    plot((indx3(i)-1+(1:length(fakeSpike2))')*dt, fakeSpike2, 'k', 'Tag', 'Fake spike 2')
end
add_legend(gca);

subplot(412)
title('convoluted signal')
plot(t, vConvoluted);
grid on

subplot(413)
title('moving avg normalized signal')
hold on
plot(t, vConvoluted./movingAvgNormalization);
plot(t(real_spike_indx), zeros(size(real_spike_indx)), 'ro', 'Tag', 'Real spike')
add_legend(gca);
grid on

subplot(414)
title('spike sum normalized signal')
hold on
plot(t, vConvoluted./spikeSumNormalization);
plot(t(real_spike_indx), zeros(size(real_spike_indx)), 'ro', 'Tag', 'Real spike')
add_legend(gca);
grid on
ylim([0 2]);

lower_threshold = .9;
upper_threshold = 1.15;
dN = vConvoluted./spikeSumNormalization;
localMax = diff(dN(1:end-1)) > 0 & diff(dN(2:end)) < 0;
localMax = localMax & dN(2:end-1) > lower_threshold & dN(2:end-1) < upper_threshold;
line(xlim, lower_threshold*[1 1]);
line(xlim, upper_threshold*[1 1]);
plot(dt * find(localMax), zeros(nnz(localMax), 1), 'ks', 'Tag', 'detected spike')
add_legend(gca);
h1 = gca;

margin = 40;
fig2 = figure(2);
clf
h2 = copyobj(h1, fig2);
setheight(h2, getheight(fig2)-2*margin);
setwidth(h2, getwidth(fig2)-2*margin);
setx(h2, margin);
sety(h2, margin);
add_legend(h2);

linkaxes(get_axes([fig1 fig2]), 'x');
