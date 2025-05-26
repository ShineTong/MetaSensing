clear
clc
No=1;
No2=1;
for i=1:10
    for ii=1:2
        csi_trace = read_bf_file(strcat('D:\College\paper\Performance Analysis of Wireless Indoor Localization with Channel State Information\matlab\sample_data\data 0720\',int2str(i),'.0m3_',int2str(ii),'.dat'));
        [packet nothing] = size(csi_trace);
        for qq=1:packet
            csi_entry = csi_trace{qq};
            csi = get_scaled_csi(csi_entry);
            f=20e6/29;
%             h1=reshape(csi(1,1,:),1,30);
%             h2=reshape(csi(1,3,:),1,30);
%             h(1,:)=h1;
%             h(2,:)=h2;
            h=reshape(csi(1,1,:),1,30);
            hh=phase(h);
            for q=1:29
               zz(No,q)=hh(1,q+1)-hh(1,q);
            end
            n=1:1;
            Rxx=zeros(30,30);
            Rxx = h(n,:)'*h(n,:);
            Rxx=Rxx;
            [V, D]=eig(Rxx);
            l=0.09;
            lambda=0.125;
            N=29;
            E(:,1:N)=V(:,1:N);
            a=zeros(N,301);
            f=20e6/29;
            if  size(csi,1)==2
                trainX(No,:)=reshape(Rxx,1,900);
                trainY(No,1)=i*10;
                No=No+1;
            end
        end
        if exist(strcat('D:\College\paper\Performance Analysis of Wireless Indoor Localization with Channel State Information\matlab\sample_data\data 0720\',int2str(i),'.2m3_',int2str(ii),'.dat'),'file')
        csi_trace = read_bf_file(strcat('D:\College\paper\Performance Analysis of Wireless Indoor Localization with Channel State Information\matlab\sample_data\data 0720\',int2str(i),'.2m3_',int2str(ii),'.dat'));
        [packet nothing] = size(csi_trace);
        for qq=1:packet
            csi_entry = csi_trace{qq};
            csi = get_scaled_csi(csi_entry);
            f=20e6/29;
%             h1=reshape(csi(1,1,:),1,30);
%             h2=reshape(csi(1,3,:),1,30);
%             h(1,:)=h1;
%             h(2,:)=h2;
            h=reshape(csi(1,1,:),1,30);
            hh=phase(h);
            for q=1:29
               zz(No,q)=hh(1,q+1)-hh(1,q);
            end
            n=1:1;
            Rxx=zeros(30,30);
            Rxx = h(n,:)'*h(n,:);
            Rxx=Rxx;
            [V, D]=eig(Rxx);
            l=0.09;
            lambda=0.125;
            N=29;
            E(:,1:N)=V(:,1:N);
            a=zeros(N,301);
            f=20e6/29;
            if  size(csi,1)==2
                trainX(No,:)=reshape(Rxx,1,900);
                trainY(No,1)=(i+0.2)*10;
                No=No+1;
            end
        end
        end
        if exist(strcat('D:\College\paper\Performance Analysis of Wireless Indoor Localization with Channel State Information\matlab\sample_data\data 0720\',int2str(i),'.4m3_',int2str(ii),'.dat'),'file')
        csi_trace = read_bf_file(strcat('D:\College\paper\Performance Analysis of Wireless Indoor Localization with Channel State Information\matlab\sample_data\data 0720\',int2str(i),'.4m3_',int2str(ii),'.dat'));
        [packet nothing] = size(csi_trace);
        for qq=1:packet
            csi_entry = csi_trace{qq};
            csi = get_scaled_csi(csi_entry);
            f=20e6/29;
%             h1=reshape(csi(1,1,:),1,30);
%             h2=reshape(csi(1,3,:),1,30);
%             h(1,:)=h1;
%             h(2,:)=h2;
            h=reshape(csi(1,1,:),1,30);
            hh=phase(h);
            for q=1:29
               zz(No,q)=hh(1,q+1)-hh(1,q);
            end
            n=1:1;
            Rxx=zeros(30,30);
            Rxx = h(n,:)'*h(n,:);
            Rxx=Rxx;
            [V, D]=eig(Rxx);
            l=0.09;
            lambda=0.125;
            N=29;
            E(:,1:N)=V(:,1:N);
            a=zeros(N,301);
            f=20e6/29;
            if  size(csi,1)==2
                trainX(No,:)=reshape(Rxx,1,900);
                trainY(No,1)=(i+0.4)*10;
                No=No+1;
            end
        end
        end
        if exist(strcat('D:\College\paper\Performance Analysis of Wireless Indoor Localization with Channel State Information\matlab\sample_data\data 0720\',int2str(i),'.6m3_',int2str(ii),'.dat'),'file')
        csi_trace = read_bf_file(strcat('D:\College\paper\Performance Analysis of Wireless Indoor Localization with Channel State Information\matlab\sample_data\data 0720\',int2str(i),'.6m3_',int2str(ii),'.dat'));
        [packet nothing] = size(csi_trace);
        for qq=1:packet
            csi_entry = csi_trace{qq};
            csi = get_scaled_csi(csi_entry);
            f=20e6/29;
%             h1=reshape(csi(1,1,:),1,30);
%             h2=reshape(csi(1,3,:),1,30);
%             h(1,:)=h1;
%             h(2,:)=h2;
            h=reshape(csi(1,1,:),1,30);
            hh=phase(h);
            for q=1:29
               zz(No,q)=hh(1,q+1)-hh(1,q);
            end
            n=1:1;
            Rxx=zeros(30,30);
            Rxx = h(n,:)'*h(n,:);
            Rxx=Rxx;
            [V, D]=eig(Rxx);
            l=0.09;
            lambda=0.125;
            N=29;
            E(:,1:N)=V(:,1:N);
            a=zeros(N,301);
            f=20e6/29;
            if  size(csi,1)==2
                trainX(No,:)=reshape(Rxx,1,900);
                trainY(No,1)=(i+0.6)*10;
                No=No+1;
            end
        end
        end
        if exist(strcat('D:\College\paper\Performance Analysis of Wireless Indoor Localization with Channel State Information\matlab\sample_data\data 0720\',int2str(i),'.8m3_',int2str(ii),'.dat'),'file')
        csi_trace = read_bf_file(strcat('D:\College\paper\Performance Analysis of Wireless Indoor Localization with Channel State Information\matlab\sample_data\data 0720\',int2str(i),'.8m3_',int2str(ii),'.dat'));
        [packet nothing] = size(csi_trace);
        for qq=1:packet
            csi_entry = csi_trace{qq};
            csi = get_scaled_csi(csi_entry);
            f=20e6/29;
%             h1=reshape(csi(1,1,:),1,30);
%             h2=reshape(csi(1,3,:),1,30);
%             h(1,:)=h1;
%             h(2,:)=h2;
            h=reshape(csi(1,1,:),1,30);
            hh=phase(h);
            for q=1:29
               zz(No,q)=hh(1,q+1)-hh(1,q);
            end
            n=1:1;
            Rxx=zeros(30,30);
            Rxx = h(n,:)'*h(n,:);
            Rxx=Rxx;
            [V, D]=eig(Rxx);
            l=0.09;
            lambda=0.125;
            N=29;
            E(:,1:N)=V(:,1:N);
            a=zeros(N,301);
            f=20e6/29;
            if  size(csi,1)==2
                trainX(No,:)=reshape(Rxx,1,900);
                trainY(No,1)=(0.8+i)*10;
                No=No+1;
            end
        end
        end
    end
end


 
        csi_trace = read_bf_file(strcat('D:\College\paper\Performance Analysis of Wireless Indoor Localization with Channel State Information\matlab\sample_data\data 0718\2.0m2.dat'));
        [packet nothing] = size(csi_trace);
        for qq=1:packet
            csi_entry = csi_trace{qq};
            csi = get_scaled_csi(csi_entry);
%             h1=reshape(csi(1,1,:),1,30);
%             h2=reshape(csi(1,3,:),1,30);
%             h(1,:)=h1;
%             h(2,:)=h2;
            n=1:1;
            h=reshape(csi(1,1,:),1,30);
            Rxx=zeros(30,30);
            Rxx = h(n,:)'*h(n,:);
            if  size(csi,1)==2
                testX(No2,:)=reshape(Rxx,1,900);
                testY(No2,1)=3;
                No2=No2+1;
            end
        end
    


model=svmtrain(trainY,trainX,'-s 0 -t 0');
[predicted_label, accuracy, decision_values]=svmpredict(testY,testX,model);

