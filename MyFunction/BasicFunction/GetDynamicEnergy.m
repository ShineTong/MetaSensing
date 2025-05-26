function FeatureSet = GetDynamicEnergy(SystemParam,FeatureSet)
    CSI_Value = abs(FeatureSet.Processed_CSI_Value);
    Fs = SystemParam.Sample_Frequency;
    WinStep = SystemParam.SSNR_WinStep;
    WinSize = SystemParam.SSNR_WinSize;
    HampelWindow = SystemParam.SSNR_Hampel_Window;
    SmoothWindow = SystemParam.SSNR_Smooth_Window;
    HampelStd = SystemParam.SSNR_Hampel_Std;
    
    TestNumber = floor((length(CSI_Value) - WinSize)/WinStep);
    
    StaticEnergy = size(TestNumber,1);
    DynamicEnergy = size(TestNumber,1);
    for i = 1:1:TestNumber     
        StaticEnergy(i) = mean(CSI_Value((i - 1) * WinStep + 1:i * WinStep + WinSize,1));
        DynamicEnergy(i) = std(CSI_Value((i - 1) * WinStep + 1:i * WinStep + WinSize,1) - StaticEnergy(i));    
    end
    

    StaticEnergy = hampel(StaticEnergy,HampelWindow,HampelStd);
    StaticEnergy = smooth(StaticEnergy,SmoothWindow);
    
    DynamicEnergy = hampel(DynamicEnergy,HampelWindow,HampelStd);
    DynamicEnergy = smooth(DynamicEnergy,SmoothWindow);
    
    DynamicRatio = log(DynamicEnergy./StaticEnergy);
    DynamicEnergy = log(DynamicEnergy);
    StaticEnergy = log(StaticEnergy);
    
    
    T_Seq = (1:1:TestNumber) * WinStep / Fs;
    T_Seq = T_Seq';
    
    new_time_stamp = SystemParam.Feature_Time_Slot;
    FeatureSet.DynamicEnergy = interp1(T_Seq, DynamicEnergy, new_time_stamp, 'linear');
    FeatureSet.StaticEnergy = interp1(T_Seq, StaticEnergy, new_time_stamp, 'linear');
    FeatureSet.DynamicRatio = interp1(T_Seq, DynamicRatio, new_time_stamp, 'linear');
end