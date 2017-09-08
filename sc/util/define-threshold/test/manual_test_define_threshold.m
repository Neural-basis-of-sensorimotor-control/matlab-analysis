clc
close all
clear

v = sin(0:.1:pi/2);
dt = 1e-5;

thr = DefineThreshold.define(v, dt)