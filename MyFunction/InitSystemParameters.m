function SystemParam = InitSystemParameters()
    SystemParam.Sample_Frequency = 1000;
    SystemParam.Feature_Sample_Rate = 10;
    SystemParam.Feature_Time_Slot = [];
    %% 原始CSI数据的处理
    SystemParam.Denoise_Type = 'Ratio';
    SystemParam.Enable_Interp = true;
    SystemParam.Interp_Frequency = 1000;
    %% 子载波相关性的参数配置
    SystemParam.Subcarrier_CorrWindowSize = 100;
    SystemParam.Subcarrier_CorrWindowStep = 50;
    %% C-STD（CrossTrack）的参数配置
    SystemParam.Cross_WinSize = 100;
    SystemParam.Cross_WinStep = 50;
    SystemParam.Cross_Threshold = 3;
    %% SSNR Energy
    SystemParam.SSNR_WinSize = 100;
    SystemParam.SSNR_WinStep = 20;
    SystemParam.SSNR_Hampel_Window = 10;
    SystemParam.SSNR_Hampel_Std = 1;
    SystemParam.SSNR_Smooth_Window = 20;
    %% 预处理相关参数
    SystemParam.Antenna_Index = 'Ant 1/2';
    SystemParam.Enable_Hampel_Filter = true;
    SystemParam.Enable_Smooth_Filter = true;
    SystemParam.CSI_Hampel_Window = 10;
    SystemParam.CSI_Hampel_Std = 1;
    SystemParam.CSI_Smooth_Window = 10;
    %% PLCR特征求解方法
    SystemParam.Feature_Mode = 'STFT';
    SystemParam.Feature_Type = 'Smooth';
    SystemParam.Enable_Filter = true;
    SystemParam.Filter_Frequency = 60;
    SystemParam.Enable_Advanced_Customization = false;
    SystemParam.PLCR_Hampel_Window = 5;
    SystemParam.PLCR_Hampel_Std = 1;
    SystemParam.PLCR_Smooth_Window = 10;
    SystemParam.PLCR_FFT_Length = 1024;
    SystemParam.PLCR_Win_Size = 128;
    SystemParam.PLCR_Win_Step = 29;
end