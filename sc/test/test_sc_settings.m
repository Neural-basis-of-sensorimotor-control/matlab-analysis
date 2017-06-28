function tests = test_sc_settings


global dir_1 dir_2 fname_1 fname_2 folder_1 folder_2

dir_1            = 'temporary-files-1';
dir_2            = 'temporary-files-2';
fname_1 = 'ABCD1_sc.mat';
fname_2 = 'ABCD2_sc.mat';
folder_1 = 'AFNR131216_1';
folder_2 = 'AFNR131216_1';

tests = functiontests(localfunctions);

end

function setupOnce(~)

global dir_1 dir_2 fname_1 fname_2 folder_1 folder_2

if ~exist(dir_1, 'dir'), mkdir(dir_1), end
if ~exist(dir_2, 'dir'), mkdir(dir_2), end

delete([dir_1 filesep '*_sc.mat']);
delete([dir_2 filesep '*_sc.mat']);

addpath(dir_1);
addpath(dir_2);

set_raw_data_dir('D:\raw_data\mat');

create_experiment(dir_1, fname_1, folder_1);
create_experiment(dir_1, fname_2, folder_2);
create_experiment(dir_2, fname_1, folder_1);
create_experiment(dir_2, fname_2, folder_2);


  function create_experiment(dir_name, fname, folder)
    
    
    experiment = ScExperiment();
    
    
    file1 = ScFile(experiment, [get_raw_data_dir() folder filesep 'AFNR0000.mat']);
    file2 = ScFile(experiment, [get_raw_data_dir() folder filesep 'AFNR0001.mat']);
    file3 = ScFile(experiment, [get_raw_data_dir() folder filesep 'AFNR0002.mat']);
    
    file1.init();
    file2.init();
    file3.init();
    
    experiment.add(file1);
    experiment.add(file2);
    experiment.add(file3);
    
    save_experiment(experiment, [dir_name filesep fname], '-f');
    
  end

delete(get_sc_settings_filename());

end

function test_load_last_experiment(testcase)

global dir_1 dir_2 fname_1 fname_2 folder_1 folder_2

file_11 = [dir_1 filesep fname_1];
file_22 = [dir_2 filesep fname_2];

h1 = sc(file_11);
last_experiment_1 = h1.viewer.experiment;

[last_expr, fullfile_last_expr] = get_last_experiment();

verifyEqual(testcase, file_11, fullfile_last_expr);
verifyEqual(testcase, fname_1, last_expr);
%verifyEqual(testcase, folder_1, get_raw_data_dir());

h2 = sc;

verifyEqual(testcase, h2.viewer.experiment.abs_save_path, last_experiment_1.abs_save_path);

h3 = sc(file_22);

[last_expr, fullfile_last_expr] = get_last_experiment();

verifyEqual(testcase, file_22, fullfile_last_expr);
verifyEqual(testcase, fname_2, last_expr);
%verifyEqual(testcase, folder_2, get_raw_data_dir());

verifyNotSameHandle(testcase, h3.viewer.experiment, last_experiment_1);
verifyNotEqual(testcase, dir_1, get_default_experiment_dir());

h4 = sc(file_11);

verifyEqual(testcase, h4.viewer.experiment.abs_save_path, last_experiment_1.abs_save_path);
verifyEqual(testcase, [dir_1 filesep], get_default_experiment_dir());
%verifyEqual(testcase, folder_1, get_raw_data_dir());

end


function teardownOnce(~)

end


function setup(~)

global dir_1 dir_2

rmpath(dir_1)
rmpath(dir_2)

end


function teardown(~)

close all

end