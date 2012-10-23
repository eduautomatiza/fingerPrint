%Conexão com o BD
conn = database('testfinger', 'tcc', '123', 'com.mysql.jdbc.Driver', 'jdbc:mysql://10.0.0.100:3306/testfinger');

nPoints= 30;
nLinks = 5;
plane  = 1024;


for cadastro = 250001:500000
    
    x=randi(plane,1,nPoints);
    y=randi(plane,1,nPoints);

    mx=matDif(x);
    my=matDif(y);

    % Calcula os angulos relativos a cada pontos em relação aos outros
    % e as distancias de cada ponto com os outros pontos

    angles = rem(atan2(my,mx)+2*pi,2*pi); % e força angulos positivos;
    distAbs = mx.*mx + my.*my;

    [lixo , indexDist] = sort(distAbs, 2);
    points=indexDist(:,2:nLinks+1);

% ordena os angulos que estão contidos em points.
% Cria uma matrix com o maior angulo possivel e copia somente os angulos
% que estão indicados por points e depois ordena os angulos, desta forma
% o primero angulo é o que está no sentido antihorario a partir de zero.
    ax=repmat(2*pi,nPoints,nPoints);
    for c=1:nPoints
        ax(c,points(c,:))=angles(c,points(c,:));
    end
    [lixo2, angleDist] = sort(ax, 2);

    pointsIn = angleDist(:,1:nLinks);
    pointsDb = zeros( nPoints*nLinks*2 : 4);
    
    colnames1 = {'id_user', 'name'};
    exdata1 = {cadastro, num2str(cadastro)};
    fastinsert(conn, 'usuarios', colnames1, exdata1);
    
    colnames1 = {'id_digital', 'digital_name', 'id_user', 'coordx', 'coordy'};
    exdata1 = {cadastro, 'Dedao', cadastro, num2str(x), num2str(y)};
    fastinsert(conn, 'digital', colnames1, exdata1);
    
    idDigital = cadastro;
    
    for i = 1:nPoints
        %separado só para melhor entender os testes
        for j = 1:nLinks
            k = j + 1;
            % necessário para calcular a distância entre o último ponto e o
            % primeiro
            if k > nLinks
               k = 1; 
            end
            point1 = pointsIn(i,j);
            point2 = pointsIn(i,k);
            % Pega o ângulo próximo ponto e diminui do atual
            % ex: segundo menor ângulo menos o menor ângulo 
            difAngulo = angles(i,point2) - angles(i,point1);

            % Guarda na dimensão Z os valores para cada ângulo e a distância do
            % vetor entre o ponto analisado e o primeiro ponto

            pointsDb((i-1)*nLinks+j,:) = [...
                idDigital ...
                round(10000*rem( abs( difAngulo ) ,pi)) ...
                distAbs(i,point1) ...
                distAbs(i,point2) ...
                ];
        end
    end
    
    colTri = {'id_digital', 'angle1', 'distance1', 'distance2'};
    exTri = num2cell(pointsDb);
    fastinsert(conn, 'triangulos', colTri, exTri);

end

