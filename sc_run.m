clc

edhandle = com.mathworks.mlservices.MLEditorServices.getEditorApplication;
openeditors = edhandle.getOpenEditors;
for k=0:openeditors.size-1
    openeditors.get(k).save
end

clearclasses = 1;%0;%
clf('reset')
if clearclasses
    close all
    clear classes
else
    clear
end

sc -addpath
clear
[~, user_name] = system('echo %USERDOMAIN%\%USERNAME%');
if strcmp(deblank(user_name),'HAMO\Hannes')
    fname = 'C:\Users\Hannes\Documents\GitHub\matlab-analysis\BBNR_sc.mat';
else
    fname = 'C:\Users\hamo\Documents\MATLAB_minus_one\BBNR_sc.mat';
end
d=load(fname);
sequence = d.obj.get(1).get(1);
mgr = sc_gui.WaveformViewer(sequence);
mgr.show();
