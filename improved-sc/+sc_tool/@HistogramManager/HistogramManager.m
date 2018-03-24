classdef HistogramManager < handle
  
  properties (Dependent)
    hist_pretrigger
    hist_posttrigger
    hist_binwidth
    hist_plot_mode
  end
  
  properties (SetAccess = 'protected', SetObservable)
    m_hist_pretrigger
    m_hist_posttrigger
    m_hist_binwidth
    m_hist_plot_mode
  end
  
end