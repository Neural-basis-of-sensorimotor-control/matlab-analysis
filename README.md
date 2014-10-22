Updates in version 1.0.1: 
==========================
(Can be obtained in English by request)


1) När man vill skapa en ny experiment-fil (*_sc.mat) så skall man ju välja vilka rådatafiler som skall ingå (.mat från Spike2 eller .adq från gamla systemet). Istället för att välja en mapp så skall man markera alla filer manuellt genom att trycka ner shift-tangenten och välja flera filer. Observera att Pontus tidigare har extraherat spikar i Spike2, om rådatafilen heter ABCD0001.mat så heter hans fil ABCD0001_xxxx.mat . Man skall *inte* importera dessa filer - programmet hittar dem självt.
2) Programmet kommer numera ihåg vilken experimentfil man använde senast, och försöker ladda den igen. Detta gäller när man startar programmet som vanligt: 
>> sc
För att undvika detta beteende så kan man istället skriva
>> sc -loadnew
3) Varning för att fönstrenas layout kan vara lite lynnig. Om det är ett problem i sitt nuvarande skick, säg til så ska jag propritera att fixa det 
4) Det finns fem paneler med knappar i ett fönster ('Reset','Main','Channel selection','Plot options','Histogram')
Om man trycker på 'Update' på en av dessa paneler så uppdateras efterföljande också, bortsett från 'Histogram' som agerar oberoende av de andra.
5) Spike removal tool är ganska grov, har en förfinad version på lager men måste optimera den så att den går snabbare och inte kräver så mycket RAM
6) Om man vill spara plottar eller histogram som .dat-filer så kan man välja eget namn. Det automatiska namnvalet uppdateras när man byter sekvens.
7) Lagt till funktionalitet för att lägga till enstaka spikar manuellt (genom klick i figuren)