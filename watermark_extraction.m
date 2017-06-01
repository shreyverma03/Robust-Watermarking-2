%% Watermark extraction algorithm
function [watermark_logo_extracted, generated_signature, reconstructed_signature, LLw_4, HHw_4] = watermark_extraction(watermarked_image,U1_w,U2_w,U3_w,U4_w,V1_w,V2_w,V3_w,V4_w, watermark_logo,key)

% 1. Perform the 1-level IWT on a watermarked image(possi-bly distorted) to decompose it into four sub-bands (LL, LH, HL and HH).
[LL, HL, LH, HH] = lwt2(watermarked_image, 'db1');

reconstructed_signature = signature_extraction(LL, length(watermark_logo));

%2. Implement SVD on all sub-bands (LL, HL, LH and HH)
[U1, S1_w, V1] = svd(LL, 'econ');
[U2, S2_w, V2] = svd(HL, 'econ');
[U3, S3_w, V3] = svd(LH, 'econ');
[U4, S4_w, V4] = svd(HH, 'econ');



SigLL = signature_generation(U1_w, V1_w, key);
SigHL = signature_generation(U2_w, V2_w, key);
SigLH = signature_generation(U3_w, V3_w, key);
SigHH = signature_generation(U4_w, V4_w, key);

generated_signature = double(bitxor(uint8(SigLL), bitxor(uint8(SigHL), bitxor(uint8(SigLH), uint8(SigHH)))));


D1 = U1_w * S1_w * V1_w';
D2 = U2_w * S2_w * V2_w';
D3 = U3_w * S3_w * V3_w';
D4 = U4_w * S4_w * V4_w';

W1 = (D1 - S1_w)/ 0.005;
W2 = (D2 - S2_w)/ 0.005;
W3 = (D3 - S3_w)/ 0.005;
W4 = (D4 - S4_w)/ 0.005;


figure;
subplot(2, 2, 1);
imshow(W1, []);
title('Watermark logo');
subplot(2, 2, 2);
imshow(W2, []);
title('Watermark logo');
subplot(2, 2, 3);
imshow(W3, []);
title('Watermark logo');
subplot(2, 2, 4);
imshow(W4, []);
title('Watermark logo');
    
end