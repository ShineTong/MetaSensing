function Features = SimFeature(Para)
    FeatureType = Para.FeatureType;
    Pos_A = Para.Dev_A;
    Pos_B = Para.Dev_B;
    GroundTruthMatrix = Para.GroundTruthMatrix(2:3,:);
    TimeInter = Para.GroundTruthMatrix(1,:);
    switch FeatureType
        case 'PLCR'
            Distance = sqrt(sum((GroundTruthMatrix - Pos_A').^2)) + sqrt(sum((GroundTruthMatrix - Pos_B').^2));
            Features = diff(Distance)./diff(TimeInter);
            Features = [Features,Features(1,end)];
        case 'DPLCR'
            Distance = sqrt(sum((GroundTruthMatrix - Pos_A').^2)) - sqrt(sum((GroundTruthMatrix - Pos_B').^2));
            Features = diff(Distance)./diff(TimeInter);
            Features = [Features,Features(1,end)];
    end
end