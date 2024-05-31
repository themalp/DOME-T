function [Moments,NumMoments,RecNormError,PSNRError,T_vec,NormRec_F] = TMs(order,image,rec,plt)

RecNormError = 0;
PSNRError    = 0;

%img   = imread(image);
img=image;

F     = double(img);
[N, M] = size(F);
F(F==0)=1;

%%%%%%% Calculate Tchebichef Polynomials
Tn = Tchebichef_bar_poly(order,N);
Tm = Tchebichef_bar_poly(order,M);

%%%%%%% Calculate Tchebichef Moments
T = zeros(order+1,order+1);
cnt=1;
for n=0:order
    for m=0:order
        
        if n==150
            test=1;
        end
        
        NormFactor = (1/(p_norm(n,N)*p_norm(m,M)));
        T(n+1,m+1) = NormFactor*sum(sum((Tn(n+1,:)'*Tm(m+1,:)).*F(1:N,1:M)));
        
        T_vec(cnt) = T(n+1,m+1);
        cnt = cnt+1;
    end
end
Moments    = T;
NumMoments = cnt-1;

%%%%%%% In case the user wants reconstruction
if rec==1
    %%%%%%% Image Reconstruction
    Rec_F=zeros(N,M);
    for x=1:N
        for y=1:M
            Rec_F(x,y) = sum(sum((Tn(:,x)*Tm(:,y)').*T));
        end
    end
 
    
    %%%%%%% Image Intensity Normalization
    NormRec_F      = imnorm(Rec_F,0);
    NormRec_hist   = double(histeq(uint8(Rec_F)));
    NormRec_F_hist = double(histeq(uint8(NormRec_F)));

    %%%%%%% Compute the normalized reconstruction error and the PSNR
    RecNormError(1,1)   = (sum(sum(((F-NormRec_F)./F).^2)))/(N*M);
    RecNormError(1,2)   = (sum(sum(((F-NormRec_hist)./F).^2)))/(N*M);
    RecNormError(1,3)   = (sum(sum(((F-NormRec_F_hist)./F).^2)))/(N*M);
    
    PSNRError(1,1)      = PSNR_Error(F,NormRec_F);
    PSNRError(1,2)      = PSNR_Error(F,NormRec_hist);
    PSNRError(1,3)      = PSNR_Error(F,NormRec_F_hist);
    
    if plt==1
        %%%%%%% Plot Original & Reconstructed Images
        figure;
        subplot(2,2,1);imshow(uint8(img));title('Original Image');
        subplot(2,2,2);imshow(uint8(NormRec_F));title('Norm');
        subplot(2,2,3);imshow(uint8(NormRec_hist));title('HistEqual');
        subplot(2,2,4);imshow(uint8(NormRec_F_hist));title('Norm + HistEqual');
    end

end
NormRec_F = Rec_F; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% This function computes the Tchebichef %%%%%%%%%%%%
%%%%%%% Polynomials                           %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Tk = Tchebichef_bar_poly(nmax,N)

x = 0:N-1;
switch nmax
    case 0
        Tk(1,:) = ones(1,length(x));
    case 1
        Tk(2,:) = (2*x+1-N)/N;
    otherwise
        Tk(1,:) = ones(1,length(x));
        Tk(2,:) = (2*x+1-N)/N;
        for n = 1:nmax-1            
            ni = n+1;            
            A  = (2*ni-1)*Tk(2,:);
            B  = (ni-1)*(1-((ni-1)/N)^2);
            Tk(n+2,:) = (A.*Tk(n+1,:)-B*Tk(n,:))/(ni);
        end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% This function computes the Norm of    %%%%%%%%%%%%
%%%%%%% Krawtchouk Polynomials                %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function pnorm = p_norm(n,N)
% 
% pnorm = (factorial(2*n)/Bhta(n,N))*(nchoosek(N+n,2*n+1)/Bhta(n,N));
% 
% end

function pnorm = p_norm(n,N)

t=1-((1:n).^2)./(N^2);

pnorm=N;
for k=1:length(t)
    pnorm = pnorm*t(k);
end
pnorm = pnorm/(2*n+1);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% This function computes the Bhta parameter %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function B = Bhta(n,N)
B = N^n;
end
