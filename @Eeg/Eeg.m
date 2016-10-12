classdef Eeg < handle
  % Eeg   class object to evaluate EEG data. Quick n dirty
  % Instruktioner:
  % 1. Skriv 'h = Eeg' i kommandoprompten (en g�g)
  %       V�j vilken *_sc.mat fil som skall anv�das
  %
  % 2. Du kan nu av�da f�jande kommandon:
  % a) Kontrollera automatisk detektion av stigande flank p�EEG:t
  %   h.modify_eeg(width, threshold, nbr_of_consecutive, filenbr)
  %   h.modify_eeg(width, threshold, nbr_of_consecutive, filenbr, xlimits)
  %
  %   width = antal bins i moving average filtrering av derivatan av
  %       EEG-signalen (ett positivt heltal)
  %   threshold = vilket v�de som derivatan skall �erstiga f� att
  %       EEG:t skall klassifieras som stigande flank (valfritt tal)
  %   nbr_of_consecutive = hur m�ga derivatapunkter m�te vara �er
  %       threshold i f�jd f� att det skall klassifieras som stigande flank
  %       (ett positivt heltal)
  %   filenbr = fil-nummer i det aktuella experimentet (ett positivt heltal)
  %   xlimits [optional] = gr�ser f� x-v�det plottning av data, m�t i
  %       bin index (vektor med tv�positiva heltal, stigande)
  %
  % b) Visa resultaten:
  %   h.plot_eeg(pretrigger,posttrigger,binwidth,plottype)
  %   h.plot_eeg(pretrigger,posttrigger,binwidth,plottype,bandwidth)
  %   h.plot_eeg(pretrigger,posttrigger,binwidth,plottype,bandwidth,eeg_classification)
  %   
  %   pretrigger, posttrigger, binwidth = v�den f� histogrammet i
  %       sekunder
  %   plottype = 0 f� peristimulus histogram, 1 f� kernel density
  %       estimering
  %   bandwidth [optional] = standard dev f� kernels, ej relevant f�
  %       peristimulus histogram 
  %   eeg_classification [optional] = vektor med tre v�den: 
  %       [width threshold nbr_of_consecutive] enligt funktionen ovan.
  %       Om man anv�der peristimulus histogram s�f� man skriva in ett
  %       godtyckligt v�de f� bandwidth
  %
  % c) Spara data fr� figur till .dat fil:
  %   h.save_to_dat
  %       <V�j figur nummer>
  %   Nu sparas all data fr� denna figur som en dat fil. F�sta kolumnen 
  %   � tiden (i millisekunder), andra kolumnen � spikfrekvens f� histogrammet 
  %   i f�sta raden f�sta kolumnen, sedan f�sta raden andra kolumnen, 
  %   f�sta raden tredje kolumnen, andra raden, f�sta kolumnen etc.
  %
  properties
    exp_path
    eegtag = 'A_EEG'
  end
  methods
    function obj = Eeg(filename)
      sc('-addpath');
      if ~nargin
        [fname,pname] = uigetfile('_sc.mat');
        filename = fullfile(pname,fname);
      end
      obj.exp_path = filename;
      if isnumeric(obj.exp_path)
        fprintf('No experiment chosen, cannot proceed\n');
      end
    end
  end
end
