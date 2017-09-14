function success = init_adq_file(obj)

success       = false;
[fid, errmsg] = fopen(obj.filepath);%,'r');%,'b');%,'UTF-8');

if fid == -1

  fprintf('Error reading adq file: %s\n',errmsg);
  return

end

%00 buffersize
buffersize = fread(fid,1,'uint16');

%02 sampletime*nbrofchannels (in usec)
dt = fread(fid,1,'uint16')*1e-6;

%04 pretrigger (not used)
fread(fid,1,'uint16');

%06 number of channels
nbrofchannels = fread(fid,1,'uint8');

%07 should be 1
should_be_one = fread(fid,1,'uint8');

if should_be_one~=1
  warning('check value that should be one equals %i\n',should_be_one);
end

%08 number of sweeps
nbrofsweeps = fread(fid,1,'uint32');
N           = nbrofsweeps*buffersize;
all_zeros   = fread(fid,244,'uint8');

if nnz(all_zeros)
  warning('%i values that should equal zero differ from zero\n',nnz(all_zeros)); 
end

fclose(fid);

%update sampletime
dt = dt * nbrofchannels;

for k=1:nbrofchannels
  
  tag                           = sprintf('ch%i',k);
  signal                        = ScSignal(obj,256+(k-1)*N,'tag',tag,...
    'dt',dt,'N',N);
  signal.filter.smoothing_width = 1;
  signal.filter.artifact_width  = 0;
  
  obj.signals.add(signal);
  
end
triggerparent = ScAdqTriggerParent();

triggerparent.triggers.add(ScAdqSweeps(nbrofsweeps, buffersize*dt));
obj.stims.add(triggerparent);

success = true;

end
