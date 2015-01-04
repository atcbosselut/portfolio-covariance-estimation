function [ covariance ] = SampleCovMatrix( numStocks, prices, timeRange )
    %This function calculates the sample covariance matrix for a set of
    %stock returns
    
    format long
    
    %Set the structure of the covariance matrix
    covariance = zeros(numStocks+1,numStocks+1);
    covariance(1,2:end) = prices(1,2:end);
    covariance(2:end, 1) = prices(1,2:end)';

    %Set the temporary matrix m
    m = prices(2:(timeRange+1), 2:(numStocks+1));
    
    %Calculate the covariance matrix
    covarianceVal = (m'*m)/(numStocks-1) - mean(m)'*mean(m)*numStocks/(numStocks-1);
    covariance(2:end,2:end) = covarianceVal;
end

