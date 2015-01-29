classdef Eeg < handle
    % Eeg   class object to evaluate EEG data. Quick n dirty
    % Instruktioner:
    % 1. Skriv 'h = Eeg' i kommandoprompten (en g�ng)
    %       V�lj vilken *_sc.mat fil som skall anv�ndas
    %
    % 2. Du kan nu av�nda f�ljande kommandon:
    % a) Kontrollera automatisk detektion av stigande flank p� EEG:t
    %   h.modify_eeg(width, threshold, nbr_of_consecutive, filenbr)
    %   h.modify_eeg(width, threshold, nbr_of_consecutive, filenbr, xlimits)
    %
    %   width = antal bins i moving average filtrering av derivatan av
    %       EEG-signalen (ett positivt heltal)
    %   threshold = vilket v�rde som derivatan skall �verstiga f�r att
    %       EEG:t skall klassifieras som stigande flank (valfritt tal)
    %   nbr_of_consecutive = hur m�nga derivatapunkter m�ste vara �ver
    %       threshold i f�ljd f�r att det skall klassifieras som stigande flank
    %       (ett positivt heltal)
    %   filenbr = fil-nummer i det aktuella experimentet (ett positivt heltal)
    %   xlimits [optional] = gr�nser f�r x-v�rdet plottning av data, m�tt i
    %       bin index (vektor med tv� positiva heltal, stigande)
    %
    % b) Visa resultaten:
    %   h.plot_eeg(pretrigger,posttrigger,binwidth,plottype)
    %   h.plot_eeg(pretrigger,posttrigger,binwidth,plottype,bandwidth)
    %   h.plot_eeg(pretrigger,posttrigger,binwidth,plottype,bandwidth,eeg_classification)
    %   
    %   pretrigger, posttrigger, binwidth = v�rden f�r histogrammet i
    %       sekunder
    %   plottype = 0 f�r peristimulus histogram, 1 f�r kernel density
    %       estimering
    %   bandwidth [optional] = standard dev f�r kernels, ej relevant f�r
    %       peristimulus histogram 
    %   eeg_classification [optional] = vektor med tre v�rden: 
    %       [width threshold nbr_of_consecutive] enligt funktionen ovan.
    %       Om man anv�nder peristimulus histogram s� f�r man skriva in ett
    %       godtyckligt v�rde f�r bandwidth
    %
    % c) Spara data fr�n figur till .dat fil:
    %   h.save_to_dat
    %       <V�lj figur nummer>
    %   Nu sparas all data fr�n denna figur som en dat fil. F�rsta kolumnen 
    %   �r tiden (i millisekunder), andra kolumnen �r spikfrekvens f�r histogrammet 
    %   i f�rsta raden f�rsta kolumnen, sedan f�rsta raden andra kolumnen, 
    %   f�rsta raden tredje kolumnen, andra raden, f�rsta kolumnen etc.
    %
    properties
        exp_path
        eegtag = 'A_EEG'
    end
    methods
        function obj = Eeg()
            sc('-addpath');
            [fname,pname] = uigetfile('_sc.mat');
            obj.exp_path = fullfile(pname,fname);
            if isnumeric(obj.exp_path)
                fprintf('No experiment chosen, cannot proceed\n');
            end
        end
    end
end