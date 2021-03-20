#! /usr/bin/env bash

pasta_atual=$(pwd)
echo -e "Copie o arquivo com a lista de repositórios para:$pasta_atual\ne logo após pressione 0(zero):"
read op

if [[ "$op" = 0 ]];then
	echo -e "Olá, de qual linguagem será a lista de repositórios?"
	read ling 

	echo -e "Digite o nome do arquivo da lista de repositórios:"
	read lista;
	
	arquivo=$pasta_atual/$lista		
	IFSOLD=$IFS						
	IFS=$'\n'						
	
	mkdir -p csv-"$ling" 
	cd csv-"$ling"
	
	for link in `cat $arquivo`
	do
		owner_repo=$(echo $link | sed 's/https:\/\/github.com\///g')
		repo=$(echo $owner_repo | sed 's/\//-/g' | sed 's/.*-//g')
		echo -e "\n\tBaixando dados de pull requests do repositório $link.\n"
		nome=$(echo -e "$ling\_$repo" | sed 's/\\//g')
		curl -H "Accept: application/vnd.github.v3+json"  https://api.github.com/repos/"$owner_repo"/pulls?state=closed | grep login | tail -n 200 | sort | sed 's/"login"://g' | sed 's/[", ]//g'| uniq -c | sort -n -k1 |sort -nr|  awk '{ print $2 ", " $1}' > $nome.csv
	done
	IFS=$IFSOLD

	echo -e "\nDados de Pull Requests baixados.\n"
	date > data_da_requisicao
		
else
	clear	
	echo -e "\nPor favor execute o script novamente!"
fi