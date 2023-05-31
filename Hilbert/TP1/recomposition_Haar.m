function C = recomposition(matrice_moy, D, J)
    C_glob = sparse(2^J,J);
    for j = 1:J-1
        for k = 1:2^(J-1)
            C_glob(j+1,2*k) = (matrice_moy(j,k) + D(j,k))/sqrt(2);
            C_glob(j+1,2*k+1) = (matrice_moy(j,k) + D(j,k))/sqrt(2);
        end
    end
    C = C(2^J, 1:J);
end