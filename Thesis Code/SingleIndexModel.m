function [ covariance ] = SingleIndexModel( prices, numStocks, timeRange, SPData )
%This function estimates the covariance matrix by computing the covariances
%of each stock with that of the value-weighted S&P 500

%Set up the covariance matrix structure
covariance = zeros(numStocks+1,numStocks+1);
covariance(1, 2:end) = prices(1,2:end);
covariance(2:end, 1) = prices(1,2:end)';

%Find the starting time period for our stock return sample in the S&P
%return data
[b,c] = find(SPData == prices(2,1));
[d,c] = find(SPData == prices(timeRange+1,1));

%Find the variance of the market portfolio over our time range
marketVariance = var(SPData(b:d, 2));

%Propagate a matrix with equal vertical columns all depicting the daily return of the S&P 500 
marketReturns = SPData(b:d,2)*ones(1, numStocks);

%Set a temporary matrix with our stock return data over the time period
m = prices(2:(timeRange+1), 2:(numStocks+1));

%Calculate the betas of each stock by calculating the covariance of each
%stock's returns with the return of the S&P 500
betas = (marketReturns'*m)/(numStocks-1) - (mean(marketReturns)')*mean(m)*numStocks/(numStocks-1);
betas = betas/marketVariance;

%Calculate the covariance matrix using the formula outlined in the "9
%Estimators" paper
covarianceVal = marketVariance*(betas')*betas;
covariance(2:end,2:end) = covarianceVal;
end

