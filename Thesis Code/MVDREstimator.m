function [ w ] = MVDREstimator(covariance, numStocks, filterLength )
%This function implements the iterative auxiliary vector algorithm for
%finding the MVDR filter solution outlined in the Karystinos paper

covMat = covariance(2:end, 2:end);
v = ones(numStocks, 1);

%Calculate the final value of the MVDR filter for double checking
invCv = pinv(covMat)*v;
wmvdr = invCv/(ctranspose(v)*invCv);

%Set the gain to 1 (the sum of our weights)
rho = 1;

%Set the starting weights to be the 1/N portfolio
w = rho*v/(norm(v)^2);
count = 1;

%Initialize the auxiliary vector to be used in the algorithm
g = ones(numStocks, 1);

%For each iteration of the algorithm
while((count < filterLength))
    %Calculate the auxiliary vector
    g1 = (covMat*w(:,count) - ctranspose(v)*covMat*w(:,count)*v/(norm(v)^2));
    g = g1/norm(g1);
    %Calculate mew
    mew = (ctranspose(g)*covMat*w(:,count))/(ctranspose(g)*covMat*g);
    
    %Calculate the next weight vector
    temp = w(:, count) - mew*g;
    
    %Add the weight new weight vector to the collection of weight vectors
    w = [w temp];
    count = count + 1;
end
%Return the matrix of weight vectors for each iteration of the algorithm
end
