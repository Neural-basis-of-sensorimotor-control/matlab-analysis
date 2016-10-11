clc
close all
clear
dependent_files = matlab.codetools.requiredFilesAndProducts('sc.m');
cd('D:\sensorimotor\matlab-analysis')
existing_files=rdir(sprintf('**%s*.m',pathsep));
%%
for k=1:numel(existing_files)
    if ~sc_contains(dependent_files,[cd filesep existing_files(k).name])
        fprintf('%s\n',existing_files(k).name);
    end
end