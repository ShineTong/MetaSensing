function [FeatureSet] = CSIPreprocess(SystemParam,FeatureSet)
    CSI_Value = FeatureSet.CSI_Value;
    Antenna_Index = SystemParam.Antenna_Index;    
    switch Antenna_Index
        case 'Ant 1/2'
            CSI_Value = sum(CSI_Value(:,1,SystemParam.SubCarrier_Selector_Ind),3);
        case 'Ant 2/3'
            CSI_Value = sum(CSI_Value(:,2,SystemParam.SubCarrier_Selector_Ind),3);
        case 'Ant 3/1'
            CSI_Value = sum(CSI_Value(:,3,SystemParam.SubCarrier_Selector_Ind),3);
        case 'All'
            CSI_Value = sum(sum(CSI_Value(:,3,SystemParam.SubCarrier_Selector_Ind),3),2);
        otherwise
            error('Invalid parameter value: %s',Antenna_Index);  
    end
    if SystemParam.Enable_Hampel_Filter
        CSI_Value = hampel(real(CSI_Value),SystemParam.CSI_Hampel_Window,SystemParam.CSI_Hampel_Std) + 1i * ...
            hampel(imag(CSI_Value),SystemParam.CSI_Hampel_Window,SystemParam.CSI_Hampel_Std);
    end
    if SystemParam.Enable_Smooth_Filter
        CSI_Value = smooth(real(CSI_Value),SystemParam.CSI_Hampel_Window) + 1i * ...
            smooth(imag(CSI_Value),SystemParam.CSI_Hampel_Window);
    end
    FeatureSet.Processed_CSI_Value = CSI_Value;
    FeatureSet.CSI_Adjacent_Difference = [0;angle(diff(CSI_Value))];
end