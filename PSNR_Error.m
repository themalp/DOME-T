function PSNR_val = PSNR_Error(OrigImg,RecImg)

[N, M] = size(OrigImg);

%%%%%%% Compute MSE
MSError = (1/(N*M))*sum(sum((OrigImg-RecImg).^2));

%%%%%%% Compute PSNR
Lmax      = 255;
PSNR_val  = 10*log10(Lmax*Lmax/MSError);
