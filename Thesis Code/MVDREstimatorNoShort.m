function [ w ] = MVDREstimatorNoShort(covariance, numStocks, filterLength )
%This is an algorithm that attempts to combine the iterative algorithm for
%reaching the MVDR filter with a condition that the weight vector can only
%have values great than 0. It is non-functional at this point.
covMat = covariance(2:end, 2:end);
v = ones(numStocks, 1);

%Set the gain to 1
rho = 1;

%Set the first weight to be the 1/N portfolio
w = rho*v/(norm(v)^2);
count = 1;

%For each iteration of the filter
while((count < filterLength))
    %Set the temporary variable, a, to be our previous weight vector
    a = w(:,count);
    cvx_begin
        variable g(numStocks,1)
        minimize (temp'*covMat*temp)
        
        subject to
            
            %Set the conditions for the optimization problem
            temp = a-covMat*g/norm(g)
            temp(:) >=0
            sum(a - covMat*g/norm(g)) == 1
            
            


    cvx_end
    %normalize the auxiliary vectors
    g = g/norm(g)
    
    %Calculate mew
    mew = (ctranspose(g)*covMat*a)/(ctranspose(g)*covMat*g);   
    
    %Calculate the next weight vector
    temp = a-mew*g;
    w = [w temp];
    count = count + 1
end
