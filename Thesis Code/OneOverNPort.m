function [ variance ] = OneOverNPort( covariance, numstocks )
%This function calculates the risk of the 1/N weighted portfolio

oneOverN = zeros(1, numstocks);
for oon = 1:numstocks
    oneOverN(1,oon) = 1/numstocks; %Create weight vector with each weight being 1/N
end

variance = oneOverN*covariance(1:numstocks,1:numstocks)*(oneOverN.'); %Calculate the variance
end

