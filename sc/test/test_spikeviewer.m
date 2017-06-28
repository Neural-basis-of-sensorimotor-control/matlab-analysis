function tests = test_spikeviewer

global temp_dir experiment_filename

temp_dir = 'temporary-files';
experiment_filename = 'ABCD_sc.mat';

tests = functiontests(localfunctions);

end


function test_set_experiment(testcase)

spikeviewer = testcase.TestData.spikeviewer;
experiment = testcase.TestData.experiment;

spikeviewer.set_experiment(experiment);
verifySameHandle(testcase, spikeviewer.viewer.experiment, experiment);

end

function test_set_file(testcase)

spikeviewer = testcase.TestData.spikeviewer;
file1 = testcase.TestData.file1;
file2 = testcase.TestData.file2;
file3 = testcase.TestData.file3;

spikeviewer.set_file(2);
verifySameHandle(testcase, spikeviewer.viewer.file, file2);

spikeviewer.set_file('AFNR0002');
verifySameHandle(testcase, spikeviewer.viewer.file, file3);

spikeviewer.set_file(1);
verifySameHandle(testcase, spikeviewer.viewer.file, file1);

spikeviewer.set_file([]);
verifyEmpty(testcase, spikeviewer.viewer.file);

end

function setupOnce(testcase)

global temp_dir experiment_filename

if ~exist(temp_dir, 'dir')
  mkdir(temp_dir)
end

delete([temp_dir filesep '*_sc.mat']);
addpath(temp_dir);

experiment = ScExperiment();
folder = 'AFNR131216';

file1 = ScFile(experiment, [get_raw_data_dir() folder filesep 'AFNR0000.mat']);
file2 = ScFile(experiment, [get_raw_data_dir() folder filesep 'AFNR0001.mat']);
file3 = ScFile(experiment, [get_raw_data_dir() folder filesep 'AFNR0002.mat']);

file1.init();
file2.init();
file3.init();

experiment.add(file1);
experiment.add(file2);
experiment.add(file3);

save_experiment(experiment, [temp_dir filesep experiment_filename], '-f');

spikeviewer = GuiManager();
spikeviewer.set_experiment(experiment);

testcase.TestData.spikeviewer = spikeviewer;
testcase.TestData.experiment = experiment;
testcase.TestData.file1 = file1;
testcase.TestData.file2 = file2;
testcase.TestData.file3 = file3;

end

function teardownOnce(~)

global temp_dir

rmpath(temp_dir)


end

function setup(~)
end

function teardown(~)

close all

end