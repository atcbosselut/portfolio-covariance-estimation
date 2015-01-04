function [ w_B_matrix ] = BlockMatrixEstimator( covariance, numStocks, filterLength )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    covMat = covariance(2:end, 2:end);
    v = ones(numStocks, 1);
    v_o = v/norm(v);
    
    %Calculate the initial auziliary vector
    G1 = (covMat*v_o - (ctranspose(v_o)*covMat*v_o)*v_o);
    G = G1/norm(G1);
    
    %Calculate the initial constant that minimizes the MSE between the
    %auxiliary vector and the previous weight
    C = (ctranspose(G)*covMat*v_o)/(ctranspose(G)*covMat*G);
    count = 1;
    
    %For each iteration
    while((count < filterLength))
        %Calculate the vector sum of all the previous auxiliary vectors and MSE-minimizing constants 
        AuxSum = sum((v*C).*G,2);
        
        %Calculate the auxiliary vector
        g_i = covMat*(v_o-AuxSum) - (ctranspose(v_o)*covMat*(v_o-AuxSum))*v_o-sum((v*(ctranspose(G)*covMat*(v_o-AuxSum))').*G,2);
        g_i_norm = g_i/norm(g_i);
        
        %Calculate the constant that minimizes the MSE between the
        %auxiliary vector and the previous weight
        c_i = (ctranspose(g_i_norm)*covMat*AuxSum)/(ctranspose(g_i_norm)*covMat*g_i_norm);
        
        %Add the AVs and constants to matrices containing all AVs
        %and constants from previous iterations
        G = [G g_i_norm];
        C = [C c_i];

        count = count + 1;

    end
    rank(G)
    
    %Use the Gram-Schmidt method to make each auxiliary vector orthonormal
    %to the previous one
    R = zeros(filterLength,filterLength);
    Q = zeros(numStocks,filterLength);
    for j = 1:filterLength
        a = G(:,j);
        for i = 1:j-1
            R(i,j) = Q(:,i)'*G(:,j);
            a = a-R(i,j)*Q(:,i);
        end
        R(j,j) = norm(a);
        Q(:,j) = a/R(j,j);
    end    
    
    %Initialize the Block Matrix
    B = Q;
    
    %Initiliaze the weight matrix for each iteration of the block matrix
    w_B_matrix = zeros(84,filterLength);
    
    %Calculate the weights using the block matrix method for each number of
    %iterations
    for a = 1:filterLength
        block = B(:, 1:a);
             
        mew = inv(ctranspose(block)*covMat*block)*ctranspose(block)*covMat*v_o;
    
        w_B = v_o - block*mew;
        w_B_matrix(:,a) = w_B;
    end
    
    %Normalize the weight vector to make the weights equal to 1
    w_B_matrix = w_B_matrix/norm(v);
end

