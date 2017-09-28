classdef ScPairedSpThPoints < ScPairedNeuron
  
  methods
    varargout = print_neuron(varargin)
    varargout = compute_all_distances(varargin)
  end
  
  methods (Static)
    varargout = get_properties(varargin)
  end
  
  properties
    
    indx_pre_prespike_response
    indx_prespike_response
    indx_prespike_leading_response
    indx_prespike_trailing_response
    
    indx_perispike_leading_response
    indx_perispike_response
    indx_peri_perispike_response
    indx_perispike_trailing_response
    
    indx_postspike_response
    indx_postspike_leading_response
    indx_postspike_trailing_response
    indx_post_postspike_response
    
  end
  
  properties (Dependent)
    str_properties
  end
  
  methods
    
    function obj = ScPairedSpThPoints(varargin)
      
      obj@ScPairedNeuron(varargin{:});
      
    end
    
    
    function val = get.str_properties(~)
      
      val = ScPairedSpThPoints.get_properties();
    
    end
    
  end
  
end