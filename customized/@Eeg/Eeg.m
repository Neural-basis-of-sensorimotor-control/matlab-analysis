classdef Eeg < handle
    % Eeg   class object to evaluate EEG data. Quick n dirty
    % Instruktioner:
    % 1. Skriv 'h = Eeg' i kommandoprompten (en gång)
    %       Välj vilken *_sc.mat fil som skall användas
    %
    % 2. Du kan nu avända följande kommandon:
    % a) Kontrollera automatisk detektion av stigande flank på EEG:t
    %   h.modify_eeg(width, threshold, nbr_of_consecutive, filenbr)
    %   h.modify_eeg(width, threshold, nbr_of_consecutive, filenbr, xlimits)
    %
    %   width = antal bins i moving average filtrering av derivatan av
    %       EEG-signalen (ett positivt heltal)
    %   threshold = vilket värde som derivatan skall överstiga för att
    %       EEG:t skall klassifieras som stigande flank (valfritt tal)
    %   nbr_of_consecutive = hur många derivatapunkter måste vara över
    %       threshold i följd för att det skall klassifieras som stigande flank
    %       (ett positivt heltal)
    %   filenbr = fil-nummer i det aktuella experimentet (ett positivt heltal)
    %   xlimits [optional] = gränser för x-värdet plottning av data, mätt i
    %       bin index (vektor med två positiva heltal, stigande)
    %
    % b) Visa resultaten:
    %   h.plot_eeg(pretrigger,posttrigger,binwidth,plottype)
    %   h.plot_eeg(pretrigger,posttrigger,binwidth,plottype,bandwidth)
    %   h.plot_eeg(pretrigger,posttrigger,binwidth,plottype,bandwidth,eeg_classification)
    %   
    %   pretrigger, posttrigger, binwidth = värden för histogrammet i
    %       sekunder
    %   plottype = 0 för peristimulus histogram, 1 för kernel density
    %       estimering
    %   bandwidth [optional] = standard dev för kernels, ej relevant för
    %       peristimulus histogram 
    %   eeg_classification [optional] = vektor med tre värden: 
    %       [width threshold nbr_of_consecutive] enligt funktionen ovan.
    %       Om man använder peristimulus histogram så får man skriva in ett
    %       godtyckligt värde för bandwidth
    %
    % c) Spara data från figur till .dat fil:
    %   h.save_to_dat
    %       <Välj figur nummer>
    %   Nu sparas all data från denna figur som en dat fil. Första kolumnen 
    %   är tiden (i millisekunder), andra kolumnen är spikfrekvens för histogrammet 
    %   i första raden första kolumnen, sedan första raden andra kolumnen, 
    %   första raden tredje kolumnen, andra raden, första kolumnen etc.
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