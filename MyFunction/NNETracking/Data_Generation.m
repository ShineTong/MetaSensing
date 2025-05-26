function [training_dataset,label_dataset] = Data_Generation(SimParam)
Data_Length = SimParam.Data_Length;
Sim_Size = SimParam.Sim_Size;
x_range = SimParam.Area_Lim(1,1):SimParam.Step_Size:SimParam.Area_Lim(1,2);
y_range = SimParam.Area_Lim(1,3):SimParam.Step_Size:SimParam.Area_Lim(1,4);
dev_tx = SimParam.Dev_tx;
dev_rx = SimParam.Dev_rx;
t_interval = SimParam.T_Intervel_Sim;
dev_pair = size(dev_rx,1);
% --------------dev_rx---------------
% data_size | axis(x,y) | dev_pair
% ---------------------------------
dev_rx = repmat(dev_rx,[1,1,Data_Length]);
dev_rx = permute(dev_rx,[3,2,1]);
training_dataset = zeros(Data_Length,dev_pair + 2,Sim_Size);
label_dataset = zeros(Data_Length,2,Sim_Size);
v_dataset = zeros(Data_Length,2,Sim_Size);
% --------------pos_seq---------------
% data_size | axis(x,y) | dev_pair
% ---------------------------------
DataNum = 1;
lx = SimParam.Area_Lim(1,1); rx = SimParam.Area_Lim(1,2);
ly = SimParam.Area_Lim(1,3); ry = SimParam.Area_Lim(1,4);
a_speed = zeros(Data_Length,1);
v_act = zeros(Data_Length,1);
while DataNum <= Sim_Size
    pos_init = [rand(1,1)*(rx-lx) + lx,rand(1,1)*(ry-ly)+ly];
    v_max = 1.8;
    a_speed(1,1) = 1 * rand(1,1) * exp(2i * (rand(1,1) * pi - pi/2));
    v_act(1,1) = 0.8 * rand(1,1) * exp(2i * (rand(1,1) * pi - pi/2));

    for sim_a = 2:(Data_Length) 
        direc_rand = rand(1,1);
        ThreHold = 0.02;
        if (direc_rand < ThreHold)
            a_speed(sim_a:end,1) = 1 * rand(1,1) * exp(2i * (rand(1,1) * pi - pi/2));
        end
    end
    
    v_act = v_act(1,1) + cumsum(a_speed) * SimParam.T_Intervel_Sim;

    v_act_abs = abs(v_act);
    s_index = find(v_act_abs > v_max);
    v_act(s_index) = v_max .* exp(1i * angle(v_act(s_index)));
    v_act = smooth(v_act,5) .* exp(1i * smooth(angle(v_act),5));
    
    v_sim = [real(v_act),imag(v_act)];
    v_dataset(:,:,Sim_Size) = v_sim;
    pos_seq = pos_init + cumsum(v_sim * t_interval);

    %判断轨迹范围
    min_pos_x = min(pos_seq(:,1));
    max_pos_x = max(pos_seq(:,1));
    min_pos_y = min(pos_seq(:,2));
    max_pos_y = max(pos_seq(:,2));
    %判断轨迹是否落在界内，若不在则生成下一条
    if (min_pos_x < min(x_range) || max_pos_x > max(x_range) || min_pos_y < min(y_range) || max_pos_y > max(y_range))
        continue;
    end

    d_tx = sqrt(sum((pos_seq - dev_tx).^2,2));
    d_rx = sqrt(sum((pos_seq - dev_rx).^2,2));

    vector_widar(:,1,:) = (pos_seq(:,1,:) - dev_tx(1,1))./d_tx + (pos_seq(:,1,:) - dev_rx(:,1,:))./d_rx;
    vector_widar(:,2,:) = (pos_seq(:,2,:) - dev_tx(1,2))./d_tx + (pos_seq(:,2,:) - dev_rx(:,2,:))./d_rx;
    
    plcr = squeeze(sum(vector_widar.*repmat(v_sim,[1,1,dev_pair]),2));
    
    label_dataset(:,1:2,DataNum) = pos_seq;
    training_dataset(:,1:dev_pair,DataNum) = plcr;
    %dplcr = plcr(:,1) - plcr(:,2);
    %training_dataset(:,dev_pair + 1,DataNum) = dplcr;
    training_dataset(:,(dev_pair + 1):(dev_pair + 2),DataNum) = repmat(pos_init,[Data_Length,1]);
    DataNum = DataNum + 1;
    if (~isempty(find(DataNum == (0.1:0.1:1)*Sim_Size, 1)))
        Message = ['- Generate ',num2str(DataNum),' in ', num2str(Sim_Size), ' (',num2str(find(DataNum == (0.1:0.1:1)*Sim_Size)*10), '%) Training Data'];
        disp(Message);
    end
end
training_dataset(:,1:dev_pair,:) = training_dataset(:,1:dev_pair,:) + normrnd(0,0.2,size(training_dataset(:,1:dev_pair,:)));
%training_dataset(:,3,:) = training_dataset(:,1,:) - training_dataset(:,2,:);

FileName = 'Train_Dataset/Training_Dataset';
TrainName = 'training_dataset';
LabelName = 'label_dataset';
save(FileName,TrainName,LabelName);
end