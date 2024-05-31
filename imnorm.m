%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% This function perfroms image normalization %%%%%%%
%%%%%%% in the range [0-255]                       %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Norm_img = imnorm(img,optype)

 
im_min    = min(min(img));

if im_min<0
    Norm_img  = img+abs(im_min);
elseif im_min>255
    Norm_img  = img-im_min;
else
    Norm_img  = img;
end

im_max    = max(max(Norm_img));
if (optype==1)||(im_max>255)%for display purposes
    Norm_img  = round((Norm_img/im_max)*255);
end