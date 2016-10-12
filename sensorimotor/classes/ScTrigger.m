classdef ScTrigger < handle
  methods
    %t      Nx1 array of spike times rel to closest trigger time
    %sweep  Nx1 array of sweep number, indexed from 1 ... numel(triggertimes) 
    function [t, sweep] = perievent(obj, triggertimes, pretrigger, posttrigger)
      if isempty(triggertimes)
        t = [];
        if nargout, sweep = []; end
        return
      end
      t = nan(10*numel(triggertimes),1);
      if nargout>1,   sweep = nan(size(t));   end
      pos = 0;
      spiketimes = obj.gettimes(min(triggertimes)+pretrigger,...
        max(triggertimes)+posttrigger);
      for i=1:numel(triggertimes)
        trg = spiketimes(spiketimes>triggertimes(i)+pretrigger & ...
          spiketimes<triggertimes(i)+posttrigger)- triggertimes(i);
        t(pos+1:pos+numel(trg)) = trg;
        if nargout>1   
          sweep(pos+1:pos+numel(trg)) = i*ones(size(trg));
        end
        pos = pos + numel(trg);
      end
      t = t(1:pos);
      if nargout>1,   sweep = sweep(1:pos);   end
    end
  end
end
