classdef Signal1Viewer < handle
  
  properties (Dependent)
    Signal1
    Waveform
    Amplitude
    RemoveWaveform
    Filter
    ScaleFactor
    SmoothingWidth
    ArtifactWidth
  end
  
  properties (Abstract)
    PlotMode
  end
  
end