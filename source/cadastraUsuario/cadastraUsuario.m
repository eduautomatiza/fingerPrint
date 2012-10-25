function cadastraUsuario(nomeCadastro, pointsDb, elementOfLine)

%Conexão com o BD
conn = database('db_impressao_digital', 'tcc', '123', 'com.mysql.jdbc.Driver', 'jdbc:mysql://10.0.0.100:3306/db_impressao_digital');

% OBS: Inicialmente será utilizado várias variáveis para facilitar DEBUG

% Cadastro do usuário
colNameUsuario = {'nome'};
dataUsuario = {nomeCadastro};
fastinsert(conn, 'tb_usuario', colNameUsuario, dataUsuario); 

id_usuario = consultasSQLDeCadastro(conn,'id_usuario',nomeCadastro);

% Cadastro da Digital
colNameDigital = {'id_usuario', 'nome', 'numero_nos'};
dataDigital = {id_usuario, 'Indicador', length(elementOfLine)};
fastinsert(conn, 'tb_digital', colNameDigital, dataDigital);

id_digital = consultasSQLDeCadastro(conn,'id_digital', id_usuario);
id_digital = repmat(id_digital,length(elementOfLine),1);

% Cadastro de nos
colNameNos = {'id_digital', 'numero_conexoes'};
dataNos = [id_digital, elementOfLine];
fastinsert(conn, 'tb_nos', colNameNos, dataNos); 


noTable = consultasSQLDeCadastro(conn,'id_no', id_digital(1));

% Cadastro de triângulos
triangles = cell2mat(pointsDb);
triangles(:,1:3) = noTable(triangles(:,1:3));

colNameTriangulos = {'id_no', 'id_aresta1', 'id_aresta2', 'angulo', 'aresta1', 'aresta2'};
dataTriangulos = [triangles];
fastinsert(conn, 'tb_triangulos', colNameTriangulos, dataTriangulos); 

close(conn)