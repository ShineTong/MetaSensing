function [FeatureSet] = CSICorr(SystemParam,FeatureSet)
    CSI_Value = FeatureSet.CSI_Value;
    Fs = SystemParam.Sample_Frequency; 
    WinSize = SystemParam.Subcarrier_CorrWindowSize;
    WinStep = SystemParam.Subcarrier_CorrWindowSize;
    CSILength = floor((length(CSI_Value) - WinSize)/WinStep);
    Corr_Spectrum = zeros(30,30,CSILength,3);
    CorrCurve = ones(CSILength,3);
    RefMat = eye(30);
    for AntIndex = 1:1:3
        for i = 0:1:CSILength - 1
            CSI_Value_Tmp = squeeze(CSI_Value((i * WinStep + 1:i * WinStep + WinSize),AntIndex,:));
            CurrentSpectrum = abs(corr(CSI_Value_Tmp));
            Corr_Spectrum(:,:,i+1,AntIndex) = CurrentSpectrum;
            CurrentSpectrum = CurrentSpectrum  - RefMat;
            tmp = 0;
            for m = 3:28
                tmp = tmp + sum(CurrentSpectrum(m,m-2:m+2));
            end
            CorrCurve(i+1,AntIndex) = tmp/104;
        end
    end
    CorrCurve = mean(CorrCurve,2);
    
    CorrCurve = smooth(CorrCurve,10);
    T_Seq_Corr = (1:1:CSILength) * WinStep / Fs;
    T_Seq_Corr = T_Seq_Corr';

    new_time_stamp = SystemParam.Feature_Time_Slot;
    CorrCurve = interp1(T_Seq_Corr, CorrCurve, new_time_stamp, 'linear');
    
    FeatureSet.Corr_Curve = CorrCurve;
    FeatureSet.Corr_Spectrum = Corr_Spectrum;
end