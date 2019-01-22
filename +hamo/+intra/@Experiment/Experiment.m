classdef Experiment < handle
  
  properties (Dependent)
    recordings
  end
  
  properties (SetAccess = 'private')
    m_recordings
  end
  
end