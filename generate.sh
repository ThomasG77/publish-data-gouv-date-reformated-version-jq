
mkdir temporary
cd temporary
wget http://lecomarquage.service-public.fr/donnees_locales_v4/all_latest.tar.bz2
sudo tar jxvf all_latest.tar.bz2
sudo chmod -R 777 ../temporary

# Add header
echo "id,nom,type_service_local,code_insee_commune,site_internet,telephone,telecopie,adresse_courriel,formulaire_contact,complement1,complement2,numero_voie,service_distribution,code_postal,nom_commune" | sed 's#,#\t#g'>| prefectures.csv

# Reformat content
jq -c -r '.service[] | select(.pivot[0].type_service_local as $p | ["sous_pref", "prefecture", "prefecture_region"] | index($p) ) | [.id, .nom, .pivot[0].type_service_local, .pivot[0].code_insee_commune[0], .site_internet[0].valeur, .telephone[0].valeur, .telecopie[0], .adresse_courriel[0], .formulaire_contact[0], .adresse[0].complement1, .adresse[0].complement2, .adresse[0].numero_voie, .adresse[0].service_distribution, .adresse[0].code_postal, .adresse[0].nom_commune] | join("\t")' 2022-10-28_003346-data.gouv_local.json >> prefectures.csv
mv prefectures.csv ..
cd ..
rm -rf temporary

