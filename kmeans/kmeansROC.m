function [ROCtable] = kmeansROC(testdata, label, centroids, revolutions, metric)

interval = 1/revolutions;

normalcentroid = centroids(1,:);
distances = pdist2(testdata, normalcentroid, metric);
normdistances = 1-((distances-min(distances))/(max(distances)-min(distances)));




for i = 1:revolutions
    threshold = i * interval;
    
    type = bsxfun(@le,normdistances,threshold);
    [FPR ,TPR,accuracy,TNR,precision,fmeasure] = performance(label, type);
    ROCtable(i,1) = FPR;
    ROCtable(i,2) = TPR;
    ROCtable(i,3) = accuracy;
    ROCtable(i,4) = TNR;
    ROCtable(i,5) = precision;
    ROCtable(i,6) = fmeasure;
end