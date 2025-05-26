function WiFi_Param = InitWiFiParam()
% 初始化Wi-Fi相关参数，主要包含目标天线、目标子载波数据等

    WiFi_Param.target_ant = 2;
    % 绘制并处理target_ant的幅度
    WiFi_Param.ref_ant = 3;
    % 绘制并处理ref_ant相对于target_ant的相位差
    WiFi_Param.target_subcarrier = 6;
    % 绘制并处理target_subcarrier的幅度或相位差
    WiFi_Param.Frequency = 5.32e9;
    WiFi_Param.Light_Speed = 3e8;
    
    WiFi_Param.SampleRate = 1000;
    WiFi_Param.WindowSize = 100;
    WiFi_Param.FFT_WinStep = 20;
    WiFi_Param.UpSampleFactor = 20;
    WiFi_Param.FFT_Bin_Space = WiFi_Param.SampleRate/(WiFi_Param.WindowSize * WiFi_Param.UpSampleFactor);
    WiFi_Param.FrequencyLim = 80;
    WiFi_Param.SubcarrierNum = 30;
    WiFi_Param.AntennaNum = 3;
    WiFi_Param.SampleTime = 1/WiFi_Param.SampleRate;
    WiFi_Param.Wavelength = WiFi_Param.Light_Speed/WiFi_Param.Frequency;
    WiFi_Param.FrequencyRange = -WiFi_Param.FrequencyLim:WiFi_Param.FFT_Bin_Space:WiFi_Param.FrequencyLim;
end