#!/bin/bash

# Função de validação da script
verificaAlteracao(){
	ipServidor=$(cat /etc/hosts | grep servidorsvn)
	if [ "${ipServidor}" == "${antigoIPServidor}" ]
	then
		echo ""
		echo "Opss.. A script falhou"
	else
		echo ""
		echo "Alteração realizada com sucesso"	
	fi

	echo ""
	echo "cat /etc/hosts | grep servidorsvn"
	cat /etc/hosts | grep servidorsvn
	echo ""

}

	# Solicitando o novo IP
	echo "Digite o IP do servidor \"servidorsvn\""
	read novoIPServidor

	# Identificando o IP antigo do servidor
	antigoIPServidor=$(cat /etc/hosts | grep servidorsvn | cut -f 1)

	# Substituindo o IP do Servidor
	sudo sed -i 's/'${antigoIPServidor}'/'${novoIPServidor}'/g' /etc/hosts

	# Verificando alteração
	verificaAlteracao
