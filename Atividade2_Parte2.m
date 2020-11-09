close all; clear all;
f=fopen('test14_45w.dat','rb');
D=fread(f,[4, inf],'int16');
fclose(f);
T = D.';
data = T(:,4);
signal = data(1:800);

aquisitionFrequency = 500;
cutFrequency = 30;

[px1, w1] = pwelch(signal);
f1 = (w1)*aquisitionFrequency/2/pi;

[b,a] = butter(20, cutFrequency/(aquisitionFrequency/2), 'low');

x0=2000;
y0=100;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])

filteredData = filter(b,a,signal);
subplot(5,1,1);plot(signal);title('ECG com ruído');
subplot(5,1,2);plot(f1, log10(px1));title('Densidade Spectral - ECG com ruído');
subplot(5,1,3);plot(filteredData);title('ECG filtrado passa baixa 30Hz');

smoothed = smooth(signal, 30/length(signal));
subplot(5,1,4);plot(smoothed);title('ECG com smooth (30)');

window = 15;
h = ones(window, 1)/window;
average = filter(h, 1, signal);
subplot(5,1,5);plot(average);title('EGC moving average filter');






