clear all;
close all;
% clc ;

%% 说明
% 基带nco 本振速率 1.92M
% 基带采样率 7.68M
% 基带NCO幅度 2^8
% 码流速率 7.68M

%% 产生i,q两路基带输出序列
% 全局参数
Const_FS = 7.68e6 ;                             % 采样频率
Const_Ts = 1/Const_FS ;                         % 采样周期
Num = 5000 ;                                    % 采样序列长度
M = 16;                                         % 采用QAM16
k =log2(M);                                     % 16-QAM的帧长
QAM16_Num = Num /k;                             % 进行QAM组帧后长度                   
t = 1:Num;
Seq_Fsample = t .* Const_Ts;                    % 采样序列 ：采Num个数
Nco_t = 1 : QAM16_Num;                          % nco 序列长度与QAM组帧后长度相同
Nco_t_Seq = Nco_t .* Const_Ts;                  
%% 产生3M NCO
AMP_nco = 2^8;
f_nco = 1.92e6;
nco_sin = AMP_nco * sin(2 * pi * f_nco * Nco_t_Seq);
nco_cos = AMP_nco * cos(2 * pi * f_nco * Nco_t_Seq);

%% i路基带
xi=randi([0,1],Num,1);                           %生成随机二进制比特流
figure;
subplot(2,2,1);
stem(xi(1:50),'filled');                         %画出相应的二进制比特流信号
title('i路 二进制随机比特流');
xlabel('比特序列');ylabel('信号幅度');
xi4=reshape(xi,k,length(xi)/k);                    %将原始的二进制比特序列每四个一组分组，并排列成k行length(x)/k列的矩阵
% xsymi=bi2de(xi4.','left-msb');                    %将矩阵转化为相应的16进制信号序列
i_out = bin2dec_arry(xi4);
subplot(2,2,2);
stem(i_out(1:50));                               %画出相应的16进制信号序列
title('i路 16进制随机信号');
xlabel('信号序列');ylabel('信号幅度');


%% q路基带
xq=randi([0,1],Num,1);                           %生成随机二进制比特流
subplot(2,2,3);
stem(xq(1:50),'filled');                         %画出相应的二进制比特流信号
title('q路 二进制随机比特流');
xlabel('比特序列');ylabel('信号幅度');
xq4=reshape(xq,k,length(xq)/k);                %将原始的二进制比特序列每四个一组分组，并排列成k行length(x)/k列的矩阵
% xsymq=bi2de(xq4.','left-msb');                    %将矩阵转化为相应的16进制信号序列
q_out = bin2dec_arry(xq4);
subplot(2,2,4);
stem(q_out(1:50));                                %画出相应的16进制信号序列
title('q路 16进制随机信号');
xlabel('信号序列');ylabel('信号幅度');
% figure ;
% stem(xsymq(1:50));                                %画出相应的16进制信号序列
% title('q路 16进制随机信号');
% xlabel('信号序列');ylabel('信号幅度');

%% 调制
% xsym = xsymi+xsymq .* 1i;
mix_i = i_out .* nco_cos;
y=modulate(modem.qammod(M),q_out);  %用16QAM调制器对信号进行调制
scatterplot(y);                    %画出16QAM信号的星座图
text(real(y)+0.1,imag(y),dec2bin(xsym));
axis([-5 5 -5 5]);
% scatterplot(i_out'+q_out'); 

mix_i = i_out .* nco_cos;
mix_q = q_out .* nco_sin;
mod_iq = mix_i + mix_q.*1i;




