function Sim_Param = InitSimParam()
    Sim_Param.Sim_Size = 20000;
    Sim_Param.Data_Length = 60;
    Sim_Param.Dev_tx = [2,-2];
    Sim_Param.Dev_rx = [2,2;-2,-2];
    Sim_Param.Area_Lim = [-2.5,2.5,-2.5,2.5];

    Sim_Param.T_Intervel_Sim = 0.1;
    Sim_Param.T_Intervel_Act = 0.02;
    Sim_Param.Interp_Radio = Sim_Param.T_Intervel_Sim/Sim_Param.T_Intervel_Act;

    Sim_Param.Step_Size = 0.1;
    Sim_Param.LSTMFigure = 1;% show the LSTM training or not
    Sim_Param.Pos_Start = [0,-1.2];
end