% close all; clear; clc

cam = webcam(2);

for i = 1 : 100000000
    img = snapshot(cam);

    % Procesar imagen
    img_gray = rgb2gray(img);
    img_gray(img_gray > 100) = 0;
    img_gray(img_gray ~= 0) = 255;
    img_gray = imresize(img_gray,[28 28]);
    img_gray = (double(img_gray)/255);
    
    % Clasificar
    X = reshape(img_gray', 784, 1);
    g = perc.predecir(X);
    [~, idx] = max(g);
    idx - 1
    
    imshow(img)
end

closePreview(cam)
clear('cam')