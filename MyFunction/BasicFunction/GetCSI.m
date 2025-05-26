function [FeatureSet,SystemParam] = GetCSI(FileName,SystemParam,FeatureSet)
    DenoiseType = SystemParam.Denoise_Type;
    EnableInterp = SystemParam.Enable_Interp;
    InterpFrequency = SystemParam.Interp_Frequency;
    
    csi_trace = read_bf_file(FileName);
    csi_data = zeros(length(csi_trace),3,30);
    Time_Stamp = zeros(length(csi_trace) ,1);
    Ant_Test = zeros(floor(length(csi_trace)/500),3,30);
    AntTestID = 1;
    for data_index = 1:size(csi_trace,1)  
        csi_entry = csi_trace{data_index};	
        csi_tmp = get_scaled_csi(csi_entry);
        csi_data(data_index,:,:) = squeeze(csi_tmp(1,:,:));
        Time_Stamp(data_index) = csi_entry.timestamp_low;
        if mod(data_index,500) == 0
            Ant_Test(AntTestID,:,:) = db(abs(squeeze(csi_tmp)));
            AntTestID = AntTestID + 1;
        end
    end
    
    FeatureSet.Ant_Test = squeeze(mean(Ant_Test,1))';
    SubCarrier_Selector = min(FeatureSet.Ant_Test,[],2);
    SystemParam.SubCarrier_Selector_Ind = find(SubCarrier_Selector > 10);
    
    CSI_Value_Raw = csi_data(2:end,:,:);
    Time_Stamp = Time_Stamp(2:end)';
    Time_Stamp = (Time_Stamp - Time_Stamp(1,1))/1e6;
    SystemParam.Sample_Frequency = 1/mean(diff(Time_Stamp));
    
    if EnableInterp
        new_time_stamp = 0:1/InterpFrequency:Time_Stamp(1,end);
        CSI_Value_Raw = interp1(Time_Stamp, CSI_Value_Raw, new_time_stamp, 'linear');
        SystemParam.Sample_Frequency = InterpFrequency;
        Time_Stamp = new_time_stamp;
    end
    
    switch DenoiseType
        case 'Ratio'
            CSI_Value(:,1,:) = CSI_Value_Raw(:,1,:)./(CSI_Value_Raw(:,2,:) + 0.0001);
            CSI_Value(:,2,:) = CSI_Value_Raw(:,2,:)./(CSI_Value_Raw(:,3,:) + 0.0001);
            CSI_Value(:,3,:) = CSI_Value_Raw(:,3,:)./(CSI_Value_Raw(:,1,:) + 0.0001);
        case 'Conj'
            Q = mean(CSI_Value_Raw(1:200,3,:)./CSI_Value_Raw(1:200,1,:));
            SysSignal = CSI_Value_Raw(:,3,:) - Q.* CSI_Value_Raw(:,1,:);
            CSI_Value(:,1,:) = CSI_Value_Raw(:,1,:) .* conj(SysSignal);
            CSI_Value(:,2,:) = CSI_Value_Raw(:,2,:) .* conj(SysSignal);
            CSI_Value(:,3,:) = CSI_Value_Raw(:,3,:) .* conj(SysSignal);
            CSI_Value(:,1,:) = abs(CSI_Value_Raw(:,1,:)).*exp(1i * angle(CSI_Value(:,1,:)));
            CSI_Value(:,2,:) = abs(CSI_Value_Raw(:,2,:)).*exp(1i * angle(CSI_Value(:,2,:)));
            CSI_Value(:,3,:) = abs(CSI_Value_Raw(:,3,:)).*exp(1i * angle(CSI_Value(:,3,:)));
        case 'Raw'
            CSI_Value = CSI_Value_Raw;
        otherwise
            error('Invalid parameter value: %s',DenoiseType);  
    end
    
    FeatureMaxTime = ceil(Time_Stamp(1,end) * SystemParam.Feature_Sample_Rate);
    SystemParam.Feature_Time_Slot = (0:1:FeatureMaxTime)/SystemParam.Feature_Sample_Rate;
    FeatureSet.Feature_Time_Slot = SystemParam.Feature_Time_Slot;
    FeatureSet.CSI_Value = CSI_Value;
    FeatureSet.CSI_Time_Stamp = Time_Stamp;
end