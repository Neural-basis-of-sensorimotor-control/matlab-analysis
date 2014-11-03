classdef ScWaveform < ScTrigger & ScList
    %Response from particular neuron
    %children: ScThreshold
    properties
        parent                  %ScFile
        spike2filename          %applicable when there are extra files with 
                                %spiketimes from Spike2
        tag
        detected_spiketimes     %spiketimes that are given by ScThreshold children
        imported_spiketimes     %imported from Spike2
        predefined_spiketimes   %e.g userdefined spiketimes
        %apply_after             %ScWaveformEnum enumeration type
                
        min_isi = 1e-3          %min inter-spike interval (s)
    end
    
    properties (Dependent)
        width
    end
    
    methods
        function obj = ScWaveform(parent, tag, spike2filename)
            obj.parent = parent;
            obj.tag = tag;
            obj.spike2filename = spike2filename;
           % obj.apply_after = ScWaveformEnum.spike_removal;
        end
        
        %Load spike times from separate Spike2 file
        function sc_loadtimes(obj)
            if ~isempty(obj.spike2filename)
                fname = fullfile(obj.parent.fdir,obj.spike2filename);
                if isempty(who('-file',fname,'spikes'))
                    fprintf('Warning: could not find channel ''spikes'' in file %s.\n',fname);
                else
                    d = load(fname,'spikes');
                    obj.imported_spiketimes = d.spikes.times;
                end
            end
        end
        
        %Clear data that is loaded from external file
        function sc_clear(obj)
            obj.imported_spiketimes = [];
        end
        
        %match waveforms in ScThreshold list to vector v that is contained in
        %handle h. h must have field v, that is a Nx1 double
        %Using a handle to reduce RAM requirement
        %Returns:
        %   - spikepos  = positions in w with a match
        %   - wfarea    = Nx1 logical array with true for all points in v
        %   that are covered by a waveform
        function [spikepos,wfarea] = match_handle(obj, h)
            if size(h.v,2)>size(h.v,1), 
                h.v=h.v';   
            end
            spikepos = nan(ceil(numel(h.v)/100),1);
            pos = 0;
            wfarea = false(size(h.v));
            for k=1:obj.n
                if nargout<2
                    spikepos_temp = obj.get(k).match_handle(h,obj.min_isi);
                else
                    [spikepos_temp, wfarea_temp] = obj.get(k).match_handle(h,obj.min_isi);
                    wfarea = wfarea | wfarea_temp;
                end
                spikepos(pos+1:pos+numel(spikepos_temp)) = spikepos_temp;
                pos = pos+numel(spikepos_temp);
            end
            spikepos = spikepos(1:pos);
        end
        
        %same as match_handle but v is passed as a vector, thus it is
        %unsuitable for large vectors as it may challenge memory
        %availability
        %Returns
        %   - spikepos   
        %   - spikeindex = Nx1 double where value is 0 if no match and otherwise 
        %index from 1...:(nbr of ScThreshold) that shows which waveform is
        %covered
        function [spikepos, spikeindex] = match(obj,v)
            if size(v,2)>size(v,1), v=v';   end
            spikepos = nan(ceil(numel(v)/100),1);
            pos = 0;
            spikeindex = zeros(size(v));
            min_isi_pos = round(obj.min_isi/obj.parent.dt);
            for i=1:obj.n
                [spikepos_temp, wfarea] = obj.get(i).match(v,min_isi_pos);
                spikepos(pos+1:pos+numel(spikepos_temp)) = spikepos_temp;
                pos = pos+numel(spikepos_temp);
                spikeindex(wfarea) = i*ones(nnz(wfarea),1);
            end
            spikepos = spikepos(1:pos);
        end
        
        %Return all spike times between tmin and tmax
        function times = gettimes(obj,tmin,tmax)
               times = sc_separate(sort([obj.detected_spiketimes; obj.imported_spiketimes; ...
                   obj.predefined_spiketimes]),obj.min_isi);
               times = times(times>=tmin & times<tmax);
        end
        
        %Run through v and redo all thresholding
        function recalculate_spiketimes(obj,v,dt)
            obj.detected_spiketimes = obj.match(v)*dt;
        end
        
        %Get max width (in pixels) from ScThreshold object list
        function width = get.width(obj)
            width = max(cell2mat(obj.values('width')));
        end
    end
    methods (Static)
%         function obj = loadobj(a)
%             if isempty(a.apply_after)
%                 a.apply_after = ScWaveformEnum.artifact_filtering;
%             end
%             obj = a;
%         end
    end
end