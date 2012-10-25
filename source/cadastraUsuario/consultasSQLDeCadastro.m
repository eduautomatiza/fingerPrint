function idValue = consultasSQLDeCadastro(conn, query, parameter)

switch (query)
    case 'id_usuario'
        query = ['SELECT MAX(id_usuario) FROM tb_usuario WHERE nome like "' parameter '%"'];
    case 'id_digital'
        query = ['SELECT MAX(id_digital) FROM tb_digital WHERE id_usuario = ' num2str(parameter)];
    case 'id_no'
        query = ['SELECT id_no FROM tb_nos WHERE id_digital = ' num2str(parameter)];
    otherwise
        query = ' ';
end

result = exec(conn, query) ;
result = fetch(result);
idValue = cell2mat(result.Data);
