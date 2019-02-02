function [P_dBm,X_arry,fftPoit]=my_fft(fft_arry,Fsample,window)
    L = length(fft_arry);
    if strcmp(window,'hanning') == true
        win = hann(L);           % 汉宁窗
    end
    
    X1 = fft_arry.*win';
    NFFT = 2^nextpow2(L);
    Yf = fft(X1,NFFT)/L;
    Amp_out = 2*abs(Yf(1:NFFT/2+1));
    
    P_dBm = 10 * log10(Amp_out);
    X_arry = Fsample/2*linspace(0,1,NFFT/2+1);
    fftPoit = NFFT;


end
