# Spikeviewer

Graphical user interface to analyze data imported from Spike2
Created 2013-2019 by Hannes Mogensen, Neural Basis of Sensorimotor Control
Free to use or modify with due acknowledgement

## Release notes (6 April 2021)

To import trigger data from another system, save the data as a CSV file. Currently the name of the trigger equals the file name and the file must contain only contain numbers that are either comma-separated or separated with newline characters. The numbers correspond to timestamps in seconds since the start of the recording of the file in question.

Use the "Import triggers" button and select the file:

![Skärmklipp](https://user-images.githubusercontent.com/4321754/113716091-83a3dd00-96ea-11eb-9aa5-1e4650cb9543.PNG)

The file will now appear as a marker in the plot window, and as a trigger in the button menu (select 'Imported triggers' in the trigger parent menu):

![Skärmklipp2](https://user-images.githubusercontent.com/4321754/113716306-bd74e380-96ea-11eb-8afc-be0878fb144e.PNG)

To remove an imported trigger use the button 'Remove imported triggers':

![Skärmklipp3](https://user-images.githubusercontent.com/4321754/113716369-d087b380-96ea-11eb-83e3-07dee88f343b.PNG)

Select the trigger to be removed and click on 'Remove' button

![Skärmklipp4](https://user-images.githubusercontent.com/4321754/113719117-95d34a80-96ed-11eb-8222-9085f638ef73.PNG)

![Skärmklipp4-](https://user-images.githubusercontent.com/4321754/113719104-9370f080-96ed-11eb-9e86-1e27b353e83d.PNG)

## Saving

If the \_sc.mat file is saved the imported data will also be saved.
