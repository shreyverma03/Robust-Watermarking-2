%%  IWT - SVD Watermarking
function iwt_svd()

clear all;
close all;
clc;

%change directory
folder_name = uigetdir(pwd, 'Select Directory Where the .m Files Reside');
if ( folder_name ~= 0 )
    if ( strcmp(pwd, folder_name) == 0 )
        cd(folder_name);
    end
else
    return;
end

% read cover image & watermark logo
[cover_fname, cover_pthname] = uigetfile('*.jpg; *.png; *.tif; *.bmp', 'Select the Cover Image');
if (cover_fname ~= 0)
    cover_image = strcat(cover_pthname, cover_fname);
    cover_image = double( rgb2gray( imread( cover_image ) ) );
    cover_image = imresize(cover_image, [512 512], 'bilinear');
else
    return;
end

[watermark_fname, watermark_pthname] = uigetfile('*.jpg; *.png; *.tif; *.bmp', 'Select the Watermark Logo');
if (watermark_fname ~= 0)
    watermark_logo = strcat(watermark_pthname, watermark_fname);
    watermark_logo = double( im2bw( rgb2gray( imread( watermark_logo ) ) ) );
    watermark_logo = imresize(watermark_logo, [256 256], 'bilinear');
else
    return;
end

% Set constant variables

key = 3; % random secret key
    
[watermarked_image,U1_w,U2_w,U3_w,U4_w,V1_W,V2_w,V3_w,V4_w] = watermark_embedding(cover_image, watermark_logo, key);
    
watermark_extraction(watermarked_image, U1_w,U2_w,U3_w,U4_w,V1_W,V2_w,V3_w,V4_w, watermark_logo, key);
    
end