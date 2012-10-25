function [pointsDb, elementOfLine] = funcaoCriaCelulas(x, y, procDelaunay, nLinks)

nPoints = numel(x);
distMinimal = 1;

mx=matDif(x);
my=matDif(y);

distAbs = mx.^2 + my.^2;

points = cell(numel(x),1);
    
if(procDelaunay)
    tri = delaunay(x,y);
    for fd = 1:numel(x)
        [w1,~] = find( tri == fd );
        w1 = unique( tri( w1,: ) );
        w1 = w1(w1 ~= fd);
        points(fd) = {reshape(w1,1,[])};
    end    
else
    distAbs( distAbs < distMinimal^2 ) = Inf;
    [~ , indexDist] = sort( distAbs , 2);
   
    elementOk = sum((distAbs ~= Inf),2);
    elementOk(elementOk > nLinks) = nLinks;
    for fp = 1 : numel(x)
        points(fp) = {indexDist( fp , 1:elementOk(fp) )};
    end
end

elementOfLine = zeros(nPoints,1);
% tabela com número de elementos por célula
for i = 1:nPoints
    elementOfLine(i) = numel(points{i});
end

% Calcula os angulos relativos a cada pontos em relação aos outros
angles = atan2(my,mx)+pi; % e força angulos positivos;
ax=Inf(nPoints);
for c=1:nPoints
    ax(c,points{c})=angles(c,points{c});
end
[~, angleDist] = sort(ax, 2);


pointsIn = {nPoints,1};
for i = 1:nPoints
    pointsIn{i} = angleDist(i,1:elementOfLine(i));
end

pointsDb = cell(sum(elementOfLine),1);
posPointsDb =1;
for i = 1:nPoints
    for j = 1:elementOfLine(i)
        % necessário para calcular a distância entre o último ponto e o
        % primeiro
        point1 = pointsIn{i}(j);
        if j == elementOfLine(i)
            point2 = pointsIn{i}(1);
        else
            point2 = pointsIn{i}(j+1);
        end

        pointsDb{posPointsDb} = [...
            i ...
            point1 ...
            point2 ...
            round(10000*rem( abs( angles(i,point2) - angles(i,point1) ) ,pi)) ...
            distAbs(i,point1) ...
            distAbs(i,point2) ...
            ];
        posPointsDb = posPointsDb + 1;
    end
end
