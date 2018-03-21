clc
close all
clear
clipboard('copy', 'D:\raw_data\mat\HPNR160307');
%str = sc_file_loader.get_raw_data_file('HPNR0001.mat')
str = sc_file_loader.get_raw_data_file('HPNR160307\HPNR0002.mat')
%clipboard('copy', 'D:\backup\2017-10-04\experiment-files');
%str = sc_file_loader.get_experiment_file('HPNR_sc.mat')