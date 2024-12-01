clear;
% 高通滤波器指标，fp=15HZ,fs=5HZ,Ap<=1dB,As>=40dB
fp=20;fs=10;
Ap=1;As=40;
Fs=100;T=1/Fs;
Fs = 100;%采样频率
N = 1024;
%预畸变
wp=2*pi*fp;ws=2*pi*fs;
Wp=wp*T;Ws=ws*T;
wp_pre=2*tan(Wp/2)/T;ws_pre=2*tan(Ws/2)/T;
%转化为低通滤波器
wp_L=1;
ws_L=abs(-wp_L*wp_pre/ws_pre);
[BN,Wn]=buttord(wp_L,ws_L,Ap,As,'s');
[num_lp,den_lp]=butter(BN,Wn,'s');
%求高通滤波器的H(S);
[num_hp,den_hp]=lp2hp(num_lp,den_lp,wp_pre);
w2_BW=linspace(0,pi,512);
[num_d,den_d]=bilinear(num_hp,den_hp,Fs);
h2_BWDB_H=freqz(num_d,den_d,w2_BW);

%自行设计输入信号，验证所设计滤波器的性能。
dt = 1 / Fs;
t = dt * (1:N);
f = Fs * (0:N-1) / N;

signal = sin(2*pi*5*t) + sin(2*pi*30*t) ;
signal_1 = filter(num_d, den_d, signal);

y = fft(signal, N);
y_1 = fft(signal_1, N);

% 滤波器输出
figure(1);
plot(w2_BW*Fs/(2*pi),20*log10(abs(h2_BWDB_H)));
axis([0 20 -50 5])
title('高通滤波器频谱响应'),xlabel('频率/Hz'); ylabel('增益/dB');

figure(2);
subplot(3, 1, 1);
plot(t, signal,'color', 'b');
hold on;
plot(t, signal_1, 'color', 'red');
xlim([0, t(N-1)]);
legend('原始信号', '滤波后信号');

subplot(3, 1, 2);
plot(f, abs(y));
title('原始信号频谱'), xlabel('频率/Hz'), ylabel('幅值');

subplot(3, 1, 3);
plot(f, abs(y_1));
title('滤波器1输出信号频谱'), xlabel('频率/Hz'), ylabel('幅值');



