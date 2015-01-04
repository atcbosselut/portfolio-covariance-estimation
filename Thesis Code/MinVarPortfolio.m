function [ weights ] = MinVarPortfolio( covariance, numstocks )
%This function calculates the minimum variance portfolio for a particular
%covariance matrix of stocks
v = ones(1,numstocks);

invCv = v*pinv(covariance);
weights = invCv/(invCv*v');

end


