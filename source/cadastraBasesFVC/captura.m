% listando todos os arquivos
!find ~/Bases/ | grep -v tif | grep /pgm/ | cut -d . -f 1 > listaDeImagens.txt
% !find ~/Bases/ | grep -v tif | grep /pgm/ > listaDeImagens.txt

% Lendo o arquivo
fid = fopen('listaDeImagens.txt');
nomeDaImagem = fgetl(fid);

% Passará por todas as imagens
while ischar(nomeDaImagem)
    if system(['img_capture ' nomeDaImagem '.pgm']) == 0

       % Lendoo arquivo com as coordenadas das minúcias
       fid2 = fopen('listMinucias.int');
       m5 = fread(fid2, [2, fread(fid2, [1, 1], '*uint32')], '*uint32');
       fclose(fid2);
       
       x = double (m5(1,:));
       y = double (m5(2,:));
       
       % triangulação por Delaunay
       [pointsDb elementOfLine] = funcaoCriaCelulas(x,y,1,0);
       cadastraBaseFVC(nomeDaImagem, pointsDb, elementOfLine, 'db_tcc_delaunay')
       
       % triangulação por Delaunay
       [pointsDb elementOfLine] = funcaoCriaCelulas(x,y,0,3);
       cadastraBaseFVC(nomeDaImagem, pointsDb, elementOfLine, 'db_tcc_estrela3')
       
       % triangulação por Delaunay
       [pointsDb elementOfLine] = funcaoCriaCelulas(x,y,0,4);
       cadastraBaseFVC(nomeDaImagem, pointsDb, elementOfLine, 'db_tcc_estrela4')
       
       % triangulação por Delaunay
       [pointsDb elementOfLine] = funcaoCriaCelulas(x,y,0,5);
       cadastraBaseFVC(nomeDaImagem, pointsDb, elementOfLine, 'db_tcc_estrela5')
       
    else
        error 'Erro capturando imagem!'
        nomeDaImagem
    end
    
    nomeDaImagem = fgetl(fid);
end

fclose(fid);