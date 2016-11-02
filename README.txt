Waveform detection tool: 
==========================

>> help sc

Normal usage:

>> sc

Eeg analysis

>> help Eeg

Configure file: 
===============

Create a file named sc.xml, and put in your working directory


Structure of sc.xml file:

<sc_settings\>
  <intra_experiment_dir\>path\to\default\sc_mat\dir </intra_experiment_dir>
  <raw_data_dir>path\to\raw\data\dir</raw_data_dir>
</sc_settings>


Artfact blanking: 
=================

An additional simple artifact removal filter is added. To see whether the artifact blanking filter is on, type the following in the command prompt:

>> h.viewer.main_signal.simple_artifact_filter.is_on

ans =

     0

If the answer is 0 it is off, if the answer is 1 it is on. To turn on simple artifact removal, type

>> h.viewer.main_signal.simple_artifact_filter.is_on = true

To turn off, type

>> h.viewer.main_signal.simple_artifact_filter.is_on = false

Then remember to save if you want to keep it on, either from the GUI or by typing

>> >> h.viewer.main_signal.sc_save(false)

If the file is opened on a computer with an earlier version of the program, where the simple artifact removal tool is not installed, the artifact removal tool will be turned off by default next time it is loaded by an updated version of the program. If you prefer the default behavior to be 'on' instead of 'off', let me know.


Folder structure:
=================

The classes in the following folders are recreated each time the program is run - no need for backwards compatibility. All files here should be called from sc.m function, otherwise they should be moved to folder /util or folder /customized. Use function customized/test_depency.m to check which files are in use.

* /channelaxes
* /enumtypes
* /functions
* /layout
* /modify_threshold
* /panelcomponents
* /panels
* /viewers

The classes in the /sensorimotor folder have to be backward and forward compatible

/third-party contains files from Mathworks file sharing site

/util contains generic functions (functions that are useful to a 'general public')

/customized contains functions that are not called by the sc.m function, but are nevertheless useful for this project - though they are not general enough to be of public use

