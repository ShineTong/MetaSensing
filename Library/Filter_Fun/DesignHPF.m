function [b_value,a_value] = DesignHPF(Filter_Pass,Filter_Stop,fs)
    %高通滤波
    %使用注意事项：通带或阻带的截止频率的选取范围是不能超过采样率的一半
    rp=0.1;rs=30;%通带边衰减DB值和阻带边衰减DB值
    wp=2*pi*Filter_Pass/fs;
    ws=2*pi*Filter_Stop/fs;
    % 设计切比雪夫滤波器；
    [n,~]=cheb1ord(wp/pi,ws/pi,rp,rs);
    [b_value,a_value]=cheby1(n,rp,wp/pi,'high');
    if (false)% 此处修改为true可看频幅相应，主要查看自己所需的频率段内部是否稳定，外部衰减是否足够
        figure
        W = 0:1:fs;
        [Hb,wb]=freqz(b_value,a_value,W,fs);
        plot(wb,20*log10(abs(Hb)),'b');
        xlabel('Hz');
        ylabel('幅值/dB');
    end
end