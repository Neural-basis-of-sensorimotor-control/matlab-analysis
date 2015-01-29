function save_to_dat(~)
fignbr = input('Figur nummer:');
figs = findall(0,'type','Figure');
ind  = cell2mat({figs.Number}) == fignbr;
if ~nnz(ind)
    fprintf('Kunde inte hitta figur med nummer %i\n',fignbr);
    return
end
fig = figs(ind);
[fname,pname] = uiputfile('.dat','Save to .dat file',sprintf('%s.dat',fig.Name));
if isnumeric(fname)
    return
end
filepath = fullfile(pname,fname);
ax = get(fig,'children');
pos = nan(size(ax));
w = getwidth(fig);
for k=1:length(ax)
    pos(k) = getx(ax(k)) - gety(ax(k))*w;
end
[~,ind] = sort(pos);
ax = ax(ind);
for k=1:length(ax)
    pl = get(ax(k),'children');
    time_ms = get(pl,'xdata');
    if ~isempty(time_ms)
        time_ms = 1e3*time_ms;
        M = nan(length(ax)+1,length(time_ms));
        M(1,:) = time_ms;
        break
    end
end
if isempty(time_ms)
    fprintf('Det finns ingen data i figure %i\n',fignbr);
    return
end
for j=1:length(ax)
    pl = get(ax(j),'children');
    y = get(pl,'ydata');
    if isempty(y)
        M(j+1,:) = zeros(size(time_ms));
    else
        M(j+1,:) = y;
    end
end
str = [repmat('%g,',1,length(ax)) '%g\n'];
fid = fopen(filepath,'w');
fprintf(fid,str,M);
fclose(fid);
end