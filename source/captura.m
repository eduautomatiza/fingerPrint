if system('./img_capture') == 0
   a = imread('finger_standardized.pgm');
   imshow(a);figure(gcf);
else
    error 'Erro capturando imagem!'
end

fid = fopen('listMinucias.int');
m5 = fread(fid, [2, fread(fid, [1, 1], '*uint32')], '*uint32');
fclose(fid);

hold on;
scatter(m5(1,:),m5(2,:),'r','filled');
hold off;