function FeatureSet = GetPLCR(SystemParam,FeatureSet)
% Wireless Sensing 2025.03.08 (Shine)
% ------------------------------------------------------------------------------------------
% GetPLCR: The function to extract the plcr from the csi
% [PLCR,T_Seq] = GetPLCR(CSI_Value,Fs,'FeatureMode','Frequency','FeatureType','Coarse-grain');
%
% ######## INPUT ########
% *** CSI_Value - CSI readings (vector)
% *** Fs - sample rate of the CSI
% --------'FeatureMode'--------
% *** 'Frequency' - utilize the STFT method to extract plcr
% *** 'Phase' - utilize the phase difference method
% --------'FeatureType'--------
% *** 'Coarse-grain' - suitable for high tracking (human tracking)
% *** 'Fine-grain' - suitable for slow tracking or showing velocity changes (gait recognition)
% --------'EnableFilter'--------
% *** true or false - determine whether to enable the filter
% 
% ######## OUTPUT ########
% *** PLCR - PLCR values
% *** T_Seq - the time sequence for the PLCR
    Processed_CSI_Value = FeatureSet.Processed_CSI_Value;
    Feature_Mode = SystemParam.Feature_Mode;
    Feature_Type = SystemParam.Feature_Type;
    Enable_Filter = SystemParam.Enable_Filter;
    Filter_Frequency = SystemParam.Filter_Frequency;
    Fs = SystemParam.Sample_Frequency;
    PLCR_Spectrum = [];
    F_Seq = [];
                
    
    switch Feature_Type
       case 'Smooth'
           WinSize = 128;
           WinStep = 29;
           FFTLength = 2048;
           HampelLength = 5;
           HampelStd = 1;
           SmoothLength = 10;
       case 'Sharp'
           WinSize = 64;
           WinStep = 15;
           FFTLength = 512;
           HampelStd = 1;
           HampelLength = 30;
           SmoothLength = 50;
       otherwise
           error('Invalid parameter value: %s',MovementType);
    end
   
    if SystemParam.Enable_Advanced_Customization
        HampelLength = SystemParam.PLCR_Hampel_Window;
        HampelStd = SystemParam.PLCR_Hampel_Std;
        SmoothLength = SystemParam.PLCR_Smooth_Window;
        FFTLength = SystemParam.PLCR_FFT_Length;
        WinSize = SystemParam.PLCR_Win_Size;
        WinStep = SystemParam.PLCR_Win_Step;
    end
    
    Processed_CSI_Value = Processed_CSI_Value - mean(Processed_CSI_Value);
    if Enable_Filter
        [b_value,a_value] = DesignLPF(Filter_Frequency,Filter_Frequency + 20,Fs);
        Processed_CSI_Value = filter(b_value,a_value,Processed_CSI_Value);
    end
       
   switch Feature_Mode
       case 'STFT'
            [com_value,F_Seq,T_Seq] = stft(Processed_CSI_Value,Fs,'Window',rectwin(WinSize),'OverlapLength',WinStep,'FFTLength',FFTLength);
            PLCR_Spectrum = abs(com_value).^2;
            [~,index] = max(PLCR_Spectrum,[],1);
            plcr= - F_Seq(index) * 2.97e8/5.32e9;
            plcr = hampel(plcr,HampelLength,HampelStd);
            PLCR = smooth(plcr,SmoothLength);
       case 'Adjacent_Difference'
            CSI_Value_Phase_Difference_Before = [0;angle(diff(Processed_CSI_Value))];
            Processed_CSI_Value = abs(Processed_CSI_Value).* exp(1i * CSI_Value_Phase_Difference_Before);
            [com_value,F_Seq,T_Seq] = stft(Processed_CSI_Value,Fs,'Window',rectwin(WinSize),'OverlapLength',WinStep,'FFTLength',FFTLength);
            PLCR_Spectrum = abs(com_value).^2;
            [~,index] = max(PLCR_Spectrum,[],1);
            plcr= - F_Seq(index) * 2.97e8/5.32e9;
            plcr = hampel(plcr,HampelLength,HampelStd);
            PLCR = smooth(plcr,SmoothLength);
       otherwise
            error('Invalid parameter value: %s',FeatureMode);           
   end
   new_time_stamp = SystemParam.Feature_Time_Slot;
   FeatureSet.PLCR = interp1(T_Seq, PLCR, new_time_stamp, 'linear');
   FeatureSet.PLCR(isnan(FeatureSet.PLCR)) = 0;
   FeatureSet.PLCR_Spectrum = PLCR_Spectrum;
   FeatureSet.STFT_F_Index = F_Seq;
   FeatureSet.STFT_T_Index = T_Seq;
end