function [ returns ] = ReturnVector( prices, numStocks, timeRange )
%This function returns the a vector of stock returns for a specified time
%range
returns = zeros(2, numStocks);

%For each stock
for indreturns = 1:numStocks
   %Set up the structure of the returns vector
   returns(1, indreturns) = prices(1, indreturns + 1);

   %Find the first and last non-zero value over the time range
   discEnd = find(prices(2:(timeRange+1),indreturns+1), 1,'last') 
   discStart = find(prices(2:(timeRange+1),indreturns+1), 1,'first')
   
   %Calculate the returns of the stock
   returns(2, indreturns) = sum(prices(discStart(1)+1:discEnd(1)+1,indreturns+1),1,'double')/length(find(prices(2:(timeRange+1),indreturns+1)))
end

end

