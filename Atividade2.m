close all; clear all;
f=fopen('test08_45s.dat','rb');
D=fread(f,[4, inf],'int16');
fclose(f);
T = D.';
data = T(:,4);
signal = data(1:4000);

aquisitionFrequency = 500;
cutFrequency = 40;
centralFrequency = 60;
Tempo1=0:(1/aquisitionFrequency):((length(signal)-1)/aquisitionFrequency);

[px1, w1] = pwelch(signal);
f1 = (w1)*aquisitionFrequency/2/pi;

[b,a] = butter(20, cutFrequency/(aquisitionFrequency/2), 'low');
% [b,a] = fir1(30, cutFrequency/aquisitionFrequency/2, 'low');
[filtro, frequencia] = freqz(b,a, length(signal), 500);

x0=2000;
y0=100;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])

filteredData = filter(b,a,signal);
subplot(7,1,1);plot(Tempo1, signal);title('ECG com ruído');
subplot(7,1,2);plot(f1, log10(px1));title('Densidade Spectral - ECG com ruído');
subplot(7,1,3);plot(Tempo1, filteredData);title('ECG filtrado passa baixa 30Hz');

smoothed = smooth(signal, 30/length(signal));
subplot(7,1,4);plot(Tempo1, smoothed);title('ECG com smooth (30)');
subplot(7,1,6);plot(frequencia,abs(filtro));title('Frequencia e filtro');

window = 15;
h = ones(window, 1)/window;
average = filter(h, 1, signal);
subplot(7,1,5);plot(Tempo1, average);title('EGC moving average filter');

wo = centralFrequency/(aquisitionFrequency/2);  bw = wo/35;
[b,a] = iirnotch(wo,bw);
notchFiltered = filter(b,a,signal);
subplot(7,1,7);plot(Tempo1, notchFiltered);title('Notch');




