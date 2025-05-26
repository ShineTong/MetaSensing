function [xCDF,yCDF,net] = LSTM_Training(Load_Trace_Data,TrainingFigure,numHiddenUnits,miniBatchSize,maxEpochs,initLearnRate)
training_dataset = Load_Trace_Data.training_dataset;
label_dataset = Load_Trace_Data.label_dataset;

XTrainAll = permute(training_dataset,[3,2,1]);
YTrainAll = permute(label_dataset,[3,2,1]);
XTrainAll = mat2cell(XTrainAll,ones(1,size(XTrainAll,1)));
YTrainAll = mat2cell(YTrainAll,ones(1,size(YTrainAll,1)));
for ii = 1 :length(XTrainAll)
    XTrainAll{ii} = squeeze(XTrainAll{ii});
end
for ii = 1 :length(YTrainAll)
    YTrainAll{ii} = squeeze(YTrainAll{ii});
end
XTrain = XTrainAll(1:round(0.9*(size(XTrainAll,1))),:);
YTrain = YTrainAll(1:round(0.9*(size(YTrainAll,1))),:);

numResponses = size(YTrain{1},1);
featureDimension = size(XTrain{1},1);

layers = [ ...
    sequenceInputLayer(featureDimension)
    bilstmLayer(numHiddenUnits,'OutputMode','sequence')
    fullyConnectedLayer(numResponses)
    regressionLayer];

if (TrainingFigure == 1)
    options = trainingOptions('adam', ...
        'MaxEpochs',maxEpochs, ...
        'MiniBatchSize',miniBatchSize, ...
        'InitialLearnRate',initLearnRate, ...
        'GradientThreshold',0.5, ...
        'Plots','training-progress',...
        'Verbose',0);
else
    options = trainingOptions('adam', ...
        'MaxEpochs',maxEpochs, ...
        'MiniBatchSize',miniBatchSize, ...
        'InitialLearnRate',0.03, ...
        'GradientThreshold',0.5, ...
        'Verbose',0);
end
[net,info] = trainNetwork(XTrain,YTrain,layers,options);



XTest = XTrainAll(round(0.98*(size(XTrainAll,1))):round(0.99*(size(XTrainAll,1))),:);
YTest = YTrainAll(round(0.98*(size(YTrainAll,1))):round(0.99*(size(YTrainAll,1))),:);
YPred = predict(net,XTest,'MiniBatchSize',1);

error = [];
for i = 1:size(YPred,1)
    error(:,i) = sqrt(sum((double(YPred{i,1}) - YTest{i,1}).^2,1));
end
Error = error(:);
[yy,xx] = cdfcalc(Error);
k = length(xx);
n = reshape(repmat(1:k, 2, 1), 2*k, 1);
xCDF    = [-Inf; xx(n); Inf];
yCDF    = [0; 0; yy(1+n)];

FileName = 'Network_Param/NNE-Network';
save(FileName,'net');
end