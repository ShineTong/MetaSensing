function Trace = NNE_Tracking(PLCRMatrix,Sim_Param,net)
    Data_Length = length(PLCRMatrix);
    initpos_seq = squeeze(repmat(Sim_Param.Pos_Start,1,1,Data_Length))';
    inputdata = [PLCRMatrix,initpos_seq];
    Trace = predict(net,inputdata', 'MiniBatchSize', 1);
end