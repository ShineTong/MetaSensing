function FeatureSet = CrossDetection(SystemParam,FeatureSet)
    csi_value = FeatureSet.Processed_CSI_Value;
    WinSize = SystemParam.Cross_WinSize;
    WinStep = SystemParam.Cross_WinStep;
    Threshold = SystemParam.Cross_Threshold;
    Fs = SystemParam.Sample_Frequency;

    anglevalue = angle(csi_value);
    meanvalue = angle(mean(exp(1i * anglevalue)));
    anglediffseq = angle(exp(1i * anglevalue).* exp(-1i * meanvalue));
    win_length = WinSize;  
    step = WinStep;  % 计算步长
    % 滑窗方差
    cross_link_index = movvar(anglediffseq, win_length);
    % 由于步长不等于 1，需要采样取出步长间隔的数据
    cross_link_index = cross_link_index(1:step:end);
    % 插值对齐plcr
    CrossIndex = smoothdata(cross_link_index);
    CrossIndex = CrossIndex/Threshold;
    CrossIndex(CrossIndex>1) = 1;
    T_Seq_Cross = (1:1:length(cross_link_index)) * WinStep / Fs;
    new_time_stamp = SystemParam.Feature_Time_Slot;
    FeatureSet.CrossIndicator = interp1(T_Seq_Cross, CrossIndex, new_time_stamp, 'linear');
end