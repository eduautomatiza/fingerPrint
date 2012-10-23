%Conexão com o BD
conn = database('testfinger', 'tcc', '123', 'com.mysql.jdbc.Driver', 'jdbc:mysql://10.0.0.100:3306/testfinger');

nPoints= 30;
nLinks = 5;
plane  = 1024;
ruido = (plane*0.01)^2;

maxNumRegister = 29000;
idDigitalConsulta = randi(maxNumRegister, 1, 1);
idUserConsulta = 1;

query = ['SELECT coordx, coordy FROM digital WHERE id_user = ' num2str(idUserConsulta) ];
result = exec(conn, query) ;
result = fetch(result);
x = str2num(result.Data{1});
y = str2num(result.Data{2});
%x=randi(plane,1,nPoints);
%y=randi(plane,1,nPoints);


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
pointsDb = zeros( nPoints*nLinks : 9 );

idTriangleConsulta = '';

for i = 1:nPoints
    %separado só para melhor entender os testes
    for j = 1:nLinks
        k = j + 1;
        % necessário para calcular a distância entre o último ponto e o
        % primeiro
        varOr = ' OR ';
        if k > nLinks
           k = 1; 
           if i == nPoints
                varOr = ';';
           end
        end
        point1 = pointsIn(i,j);
        point2 = pointsIn(i,k);
        % Pega o ângulo próximo ponto e diminui do atual
        % ex: segundo menor ângulo menos o menor ângulo 
        
        difAngulo = rem(abs(angles(i,point2) - angles(i,point1)), pi);

            % Guarda na dimensão Z os valores para cada ângulo e a distância do
            % vetor entre o ponto analisado e o primeiro ponto
            deltaAngle = abs(atan(ruido/distAbs(i,point1))) + abs(atan(ruido/distAbs(i,point2)));
            deltaDist  = round(ruido);
                    
            % DebugII
%             pointsDb((i-1)*nLinks+j,:) = [...
%                 rem( abs( difAngulo - deltaAngle ) ,pi) ...
%                 difAngulo ...
%                 rem( abs( difAngulo + deltaAngle ) ,pi) ...
%                 distAbs(i,point1)   - deltaDist ...
%                 distAbs(i,point1) ...
%                 distAbs(i,point1)   + deltaDist ...
%                 distAbs(i,point2)   - deltaDist ...
%                 distAbs(i,point2) ...
%                 distAbs(i,point2)   + deltaDist];
            
            
            
        idTriangleConsulta = [ idTriangleConsulta ...
            ' distance1 BETWEEN ' num2str(distAbs(i,point1)  - deltaDist)...
                    ' and ' num2str(distAbs(i,point1)  + deltaDist) ...
            ' AND distance2 BETWEEN ' num2str(distAbs(i,point2)  - deltaDist) ...
                    ' and ' num2str(distAbs(i,point2)  + deltaDist)...
            ' AND angle1 BETWEEN ' num2str(round( 10000*rem( abs( difAngulo - deltaAngle ) ,pi)))...
                    ' and ' num2str(round( 10000*rem( abs( difAngulo + deltaAngle ) ,pi)))...
                    varOr];
    end
end

query = ['SELECT id_user FROM triangulos JOIN digital on digital.id_digital = triangulos.id_digital WHERE ' num2str(idTriangleConsulta) ];
%result = exec(conn, query) ;
%result = fetch(result);
%result.Data