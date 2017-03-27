clc
clear

neurons = {
{'ICNR0002', 'ICNR0003'}
{'ILNR0001', 'ICNR0003'}
{'IFNR0004', 'ICNR0002'}
{'IFNR0004', 'BPNR0000'}
{'BPNR0000', 'IKNR0000'}
{'IHNR0001', 'IFNR0002'}
{'BJNR0005', 'DJNR0005'}
{'IFNR0002', 'BJNR0005'}
{'DJNR0005', 'IFNR0002'}
{'DJNR0005', 'IHNR0001'}
};

for i=1:length(neurons)
  plot_several_patterns(i, neurons{i}, 2);
end