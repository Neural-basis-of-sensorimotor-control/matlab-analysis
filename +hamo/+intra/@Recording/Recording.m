classdef Recording < handle
  
  properties (Dependent)
    signals
  end
  
  properties (SetAccess = 'private')
    m_signals
  end
  
end