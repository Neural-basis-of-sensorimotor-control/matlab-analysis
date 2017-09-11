clear
close all

position_offset = 7:9:45;
v_offset = (1:length(position_offset))*.2;
lower_tol = -1*ones(size(position_offset));
upper_tol = 1*ones(size(position_offset));

threshold = ScThreshold(position_offset, v_offset, lower_tol, upper_tol);

dt = .02;
t = 0:dt:1;
y = sin(t);



plot(t, y);

thr = DefineThreshold();

thr.init_plot();

%thr.set_threshold(threshold);
