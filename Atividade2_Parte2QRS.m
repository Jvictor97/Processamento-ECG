close all; clear all;
f=fopen('test14_45w.dat','rb');
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
[filtro, frequencia] = freqz(b,a, length(signal), 500);

filteredData = filter(b,a,signal);
subplot(3,1,1);plot(Tempo1, signal);title('ECG com ruído');
subplot(3,1,2);plot(f1, log10(px1));title('Densidade Spectral - ECG com ruído');
subplot(3,1,3);plot(Tempo1, filteredData);title('ECG filtrado passa baixa 30Hz');

% Derivada
derivative = diff(filteredData);
Tempo1_derivative = 0:(1/aquisitionFrequency):((length(signal)-2)/aquisitionFrequency);

figure
subplot(4,1,1);plot(Tempo1, filteredData);title('ECG filtrado passa baixa');
subplot(4,1,2);plot(Tempo1_derivative, derivative);title('Derivada do sinal');

% Quadrática
squared_derivative = derivative.^2;
subplot(4,1,3);plot(Tempo1_derivative, squared_derivative);title('Quadrática do sinal');

% Integral - Com janela móvel
smoothed_squared_derivative = smooth(squared_derivative,5);
subplot(4,1,4);plot(Tempo1_derivative, smoothed_squared_derivative);title('Quadrática Suavizada');

% Intervalo entre picos do QRS
threshold = 0.5*max(signal);
i = 1; 
for index = 1:length(signal)
    if signal(index) > threshold
        T1(i) = index;
        i=i+1;
    end
end

f = i - 1;
j = 1;
for g=1:(f-1)
    if (T1(g+1) - T1(g)) == 1
        if signal(T1(g+1)) > signal(T1(g))
            QRS(j)=T1(g+1);
        end
    else
        j=j+1;
    end
end

% Plotando o resultado
figure
plot(Tempo1, signal);grid
hold on
stem(QRS/aquisitionFrequency, repmat(-max(signal), 1, length(QRS)))
title('Sinal de ECG')
ylabel('Amplitude')
xlabel('Tempo')

