n = 3;
p = 3;
m = 6;
I = zeros(n,1);
I = [0 1 0]';
I_barre = zeros(n,1);
I_barre = [.1 .2 .3]';
I = round(I_barre);
Q = zeros(n);
Q = [2 2 2; 2 4 5; 2 5 7];
phi_I = (I-I_barre)'*Q*(I-I_barre);
Khi = phi_I;
R = chol(Q);

% Initialisation
r = R(p,p);
g = round(-sqrt(Khi)/r + I_barre(p));
d = round(sqrt(Khi)/r + I_barre(p));
indice_cur = 0;
minimum = Khi;
[new_I,minimum] = Parcourt(p,g,d,0,Khi,I,minimum,p,r,R,I_barre,Q);
return

function [new_I,minimum] = Parcourt(indice_cur,g,d,sum_comp,Khi,new_I,minimum,p,r,R,I_barre,Q)
    if indice_cur==0
        phi = (new_I-I_barre)'*Q*(new_I-I_barre);
        display(phi)
        minimum = min(minimum,phi);
    else
        %Mise à jour du terme des sommes de carrés
        for l=indice_cur:p
            if indice_cur~=0
            sum_comp = sum_comp + (R(indice_cur,l)*(new_I(l)-I_barre(l)))^2;
            end
        end
        
        indice_copie = indice_cur;
        for i=g:d
            indice_cur = indice_copie;
            % Si la solution existe, on continue à descendre, sinon on teste
            % une autre solution
            if Khi > sum_comp
                new_I(indice_cur) = i;
                indice_cur = indice_cur-1;
                display(i)
                display(indice_cur)
                if indice_cur~=0
                    r = R(indice_cur,indice_cur);
                    g = round(-sqrt(Khi-sum_comp)/r + I_barre(p));
                    d = round(sqrt(Khi-sum_comp)/r + I_barre(p));
                end
                Parcourt(indice_cur,g,d,sum_comp,Khi,new_I,minimum,p,r,R,I_barre,Q);
            end
        end
    end
end


