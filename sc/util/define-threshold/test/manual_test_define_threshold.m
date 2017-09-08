clc
close all
clear

v = sin(0:.1:100);
dt = 1e-5;

define_threshold = DefineThreshold.define(v, dt)