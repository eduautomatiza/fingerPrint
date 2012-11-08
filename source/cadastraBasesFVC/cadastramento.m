% Teste de cadastro de 1 usuário

% Usuário insere digital e são recolhidas as informações X e Y

[x y] = geraXY400x300(42);

% Criando celulas
[pointsDb elementOfLine] = funcaoCriaCelulas(x,y,1,0);

% Cadastrando
nomeDoUsuario = 'Danti Regis';
cadastraUsuario(nomeDoUsuario,pointsDb,elementOfLine)