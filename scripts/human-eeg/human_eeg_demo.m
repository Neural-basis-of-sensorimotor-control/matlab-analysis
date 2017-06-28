
%% Förbered filen:
% |Öppna filen med hand-koordinater i en text-editor, och byt ut alla
% decimalkomman mot punkter|
% 
%% Läs in filen:

hand_file = 'Grepp - Flaska topp.txt';

[m_hand, t_hand, labels_hand] = load_hand(hand_file);
