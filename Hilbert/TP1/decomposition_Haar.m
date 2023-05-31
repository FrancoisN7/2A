function [matrice_moy, D] = decomposition(C, J)
    matrice_moy = sparse(2^J,J);
    D = sparse(2^J,J);
    matrice_moy(1, 1:2^J) = C;
    J = J/2;
    for j = 1:J
        for k = 1:2^(J-1)
            matrice_moy(j,k) = (matrice_moy(j+1,2*k) + matrice_moy(j+1,2*k+1))/sqrt(2);
            D(j,k) = (matrice_moy(j+1,2*k) - matrice_moy(j+1,2*k+1))/sqrt(2);
        end
    end
end