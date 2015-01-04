function [ weights ] = NoShortingMinVarPort( covariance, numstocks )
%This function calculates the minimum variance portfolio we can achieve
%using only positive weights
v = ones(1,numstocks);

%Use the convex optimization library to iterate until the minimum variance
%portfolio with only positive weights is found
cvx_begin
    
    variable x(1, numstocks);
    minimize (x*covariance*x');
    %These are the two conditions that must be kept throughout the
    %minimization
    sum(x) == 1;
    x(:) >= 0;
        

cvx_end

weights = x;

end

