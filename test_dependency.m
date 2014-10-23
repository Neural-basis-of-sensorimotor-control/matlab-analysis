clc
close all
clear
dependent_files = matlab.codetools.requiredFilesAndProducts('sc.m');
cd('C:\Users\Hannes\Documents\GitHub\matlab-analysis')
existing_files=rdir('**\*.m');
%%
for k=1:numel(existing_files)
    if ~sc_contains(dependent_files,[cd filesep existing_files(k).name])
        fprintf('%s\n',existing_files(k).name);
    end
end