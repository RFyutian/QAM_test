clear all;
close all;
clc ;

%% 产生一个14位ADC输出序列
Const_FS = 5.76e6 ;                             % 采样频率
Const_Ts = 1/Const_FS ;                         % 采样周期
Num = 2000 ;                                    % 采样序列长度
t = 1:Num;
Seq_Fsample = t .* Const_Ts;                    % 采样序列 ：采Num个数
Noise_Amp = 2^2-1;                              % 噪声幅值
ADC_fullscale = 2^8-1;                         % adc 最大值，adc格式为二进制补码
fp = 0.76e6 ;                                   % passband freq = 760kHz
fs = 1.44e6 ;                                   % stopband freq = 1.44MHz

A1 = 2^12;
f1 = 200e3 ;                                    % 输入频率点1 ：200kHz
A2 = 58541 ;
f2 = 400e3 ;
A3 = 45536 ;
f3 = 750e3 ;
A4 = 5222 ;
f4 = 800e3 ;
A5 = 62882 ;
f5 = 1.2e6 ;
A6 = 6952 ;
f6 = 2.2e6 ;
fa = A1 * cos(2 * pi * f1 * Seq_Fsample) + A2 * cos(2 * pi * f2 * Seq_Fsample) + ...
        A3 * cos(2 * pi * f3 * Seq_Fsample) + A4 * cos(2 * pi * f4 * Seq_Fsample) + ...
        A5 * cos(2 * pi * f5 * Seq_Fsample) + A6 * cos(2 * pi * f6 * Seq_Fsample) ;
%取整
fa = round(fa);         %四舍五入
figure ;  
subplot(2,2,1);
plot(fa);
plot(Seq_Fsample,fa);
title('加噪前时域波形 X(t)');
xlabel('t/(s)');
ylabel('Pout');
% 打印频谱
[fft_fa,X_arry,] = my_fft(fa,Const_FS,'hanning');
subplot(2,2,2);
plot(X_arry,fft_fa);
title('加噪前频谱X(t)');
xlabel('f/(Hz)');
ylabel('P1/(dBm)');
% 加入高斯噪声
GussNoise = Noise_Amp * randn(1,length(fa));        %噪声
fa = fa + GussNoise;
subplot(2,2,3);
plot(fa);
plot(Seq_Fsample,fa);
title('加噪后时域波形 X(t)');
xlabel('t/(s)');
ylabel('Pout');
% 打印频谱
[fft_fa,X_arry] = my_fft(fa,Const_FS,'hanning');
subplot(2,2,4);
plot(X_arry,fft_fa);
title('加噪后频谱X(t)');
xlabel('f/(Hz)');
ylabel('P1/(dBm)');

%% 进行fir滤波
% 导入滤波器系数
% fid = fopen('fir_lp_fs5p76_fp0p76_fs1p44_coe.dat');
% fir1_coe = textscan(fid,'%d');
% fclose(fid);
fir1_coe = textread('fir_lp_fs5p76_fp0p76_fs1p44_coe.dat');
CoeAmp = 2^16;
fa_filter_out = filter(fir1_coe,1,fa);          %fir滤波器
fa_filter_out = fa_filter_out./CoeAmp;
fa_filter_out = round(fa_filter_out);         %四舍五入
figure ;  
subplot(2,1,1);
plot(Seq_Fsample,fa_filter_out);
title('时域波形 X(t)');
xlabel('t/(s)');
ylabel('Pout');
% 打印频谱
[fft_fa,X_arry] = my_fft(fa_filter_out,Const_FS,'hanning');
subplot(2,1,2);
plot(X_arry,fft_fa);
title('Spectrum of X(t)');
xlabel('f/(Hz)');
ylabel('P1/(dBm)');



