%watermarking embedding
function [watermarked_image,U1_w_,U2_w_,U3_w_,U4_w_,V1_w_,V2_w_,V3_w_,V4_w_] = watermark_embedding(cover_image, watermark_logo, key)

%Apply the 1-level IWT to decompose the host image into four sub-bands, named LL, HL, LH and HH.
[LL,HL,LH,HH] = lwt2(cover_image,'haar');

%Perform SVD on all sub-bands
[U1, S1, V1] = svd(LL, 'econ');
[U2, S2, V2] = svd(HL, 'econ');
[U3, S3, V3] = svd(LH, 'econ');
[U4, S4, V4] = svd(HH, 'econ');
    cod_cA1 = wcodemat(LL);
    cod_cH1 = wcodemat(HL);
    cod_cV1 = wcodemat(LH);
    cod_cD1 = wcodemat(HH);
    dec2d = [cod_cA1, cod_cH1; cod_cV1, cod_cD1];
    
    % Plot one step decomposition
    figure;
    image(dec2d);
    title('One step DWT decomposition');
    
    clear('dec2d', 'cod_cA1', 'cod_cH1', 'cod_cV1', 'cod_cD1');

[x y]=size(watermark_logo);
watermark_logo=double(watermark_logo);
alfa = 0.05;
for i=1:x
for j=1:y
     S1(i,j) =S1(i,j) + alfa * watermark_logo(i,j);
   end 
end
[U1_w, S1_w, V1_w] = svd(S1,'econ');

U1_w_ = U1_w;
V1_w_ = V1_w;

alfa1 = 0.005;
for i=1:x
for j=1:y
     S2(i,j) =S2(i,j) + alfa1 * watermark_logo(i,j);
   end 
end
[U2_w, S2_w, V2_w] = svd(S2,'econ');

U2_w_ = U2_w;
V2_w_ = V2_w;

for i=1:x
for j=1:y
     S3(i,j) =S3(i,j) + alfa1 * watermark_logo(i,j);
   end 
end
[U3_w, S3_w, V3_w] = svd(S3,'econ');

U3_w_ = U3_w;
V3_w_ = V3_w;

for i=1:x
for j=1:y
     S4(i,j) =S4(i,j) + alfa1 * watermark_logo(i,j);
   end 
end
[U4_w, S4_w, V4_w] = svd(S4,'econ');

U4_w_ = U4_w;
V4_w_ = V4_w;
%Apply the signature generation procedure to the four corre-sponding sets
SigLL = signature_generation(U1_w, V1_w, key);
SigHL = signature_generation(U2_w, V2_w, key);
SigLH = signature_generation(U3_w, V3_w, key);
SigHH = signature_generation(U4_w, V4_w, key);

SigFinal = double(bitxor(uint8(SigLL), bitxor(uint8(SigHL), bitxor(uint8(SigLH), uint8(SigHH)))));

%New modified IWT coefficients for each sub-band are per-formed as follows:
A1new = U1 * S1_w * V1';
A2new = U2 * S2_w * V2';
A3new = U3 * S3_w * V3';
A4new = U4 * S4_w * V4';

%faltu
watermark_image = ilwt2(A1new, A2new, A3new, A4new, 'haar');

A1new_sig = signature_embedding(A1new, SigFinal);
watermarked_image = ilwt2(A1new_sig, A2new, A3new, A4new, 'haar');



figure;
subplot(2, 2, 1);
imshow(cover_image, []);
title('Cover image');
subplot(2, 2, 2);
imshow(watermarked_image, []);
title('Watermarked image');
subplot(2, 2, 3);
imshow(watermark_logo, []);
title('Watermark logo');


clear('LL', 'HL', 'LH', 'HH','U1', 'S1', 'V1','U2', 'S2', 'V2','U3', 'S3', 'V3','U4', 'S4', 'V4');
%clear('U1_w','S1_w','V1_w','U2_w','S2_w','V2_w','U3_w','S3_w','V3_w','U4_w','S4_w','V4_w')

clear('A1new','A2new','A3new','A4new');

end