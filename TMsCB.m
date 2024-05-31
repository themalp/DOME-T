function [ Moms, Tn,Tm] = TMs2( img, order )

F = double( img );
[ N, M ] = size( F );


Tn = Tchebichef_bar_poly( order, N );
Tm = Tchebichef_bar_poly( order, M );


T = zeros( order, order);
for n = 0:order-1
    for m = 0:order-1
        T( n + 1, m + 1 ) = sum( sum( (Tn( n + 1, : )'* Tm( m + 1, : )) .* F( 1:N, 1:M ) ) );
    end
end
Moms = T;

end


function Tk = Tchebichef_bar_poly( nmax, N )

x = 0:N - 1;
w = 2*x-N+1;
w1= sqrt((N*N-1)/3);

switch nmax
    case 0
        Tk( 1, : ) = ones( 1, length( x ) )/sqrt(N);
    case 1
        Tk( 2, : ) = (w ./ w1).*ones( 1, length( x ) )/sqrt(N);
    otherwise
        Tk( 1, : ) = ones( 1, length( x ) )/sqrt(N);
        Tk( 2, : ) = (w ./ w1).*Tk( 1, : );
        
        
        %n+1 --> m so n=m-1
        for m = 3:nmax
            ni=m-1;
            w2_A = N^2-ni^2;
            w2_B = (2*ni+1)*(2*ni-1);
            w2   = ni*sqrt(w2_A/w2_B);
            Tk(m,:) = w./w2.*Tk(m-1,:) - w1/w2*Tk(m-2,:);
            
            w1 = w2;
            T = Tk(m,:);
            for k=0:ni
                Tk(m,:) =  Tk(m,:) - sum(T.*Tk(k+1,:))*Tk(k+1,:);
            end
            h=sqrt(sum(Tk(m,:).^2));
            Tk(m,:) = Tk(m,:)/h;
        end
end
end