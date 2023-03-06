#!/bin/bash

# Donwload jrc-acquis data
#uncomment to install jrc-aquis data usning links provided in conf/jrc_aquis_links.txt
input="./conf/jrc_aquis_links.txt"
dataset_split="./Iterative_Split/JRC_Aquis"

mkdir tmp

echo "Download JRC-Acquis data ..."
while IFS= read -r url
do
  echo "$url"
  filename="$(basename -- $url)"
  wget -nc -P tmp/ $url
  tar  -C tmp/ -xzvf tmp/$filename
done < "$input"

echo "Download and prepare eurovoc data and eurovoc analysis tool ..."
wget -nc http://publications.europa.eu/resource/cellar/fb5bc6f8-a143-11ed-b508-01aa75ed71a1.0001.07/DOC_1&fileName=eurovoc_xml.zip -O tmp/eurovoc_xml.zip
https://op.europa.eu/o/opportal-service/euvoc-download-handler?cellarURI=http%3A%2F%2Fpublications.europa.eu%2Fresource%2Fcellar%2Ffb5bc6f8-a143-11ed-b508-01aa75ed71a1.0001.07%2FDOC_1&fileName=eurovoc_xml.zip
unzip tmp/eurovoc_xml.zip -d tmp/EuroVoc
python prepare_eurovoc.py

# prepare jrc-aquis datasets
echo "Prepare JRC-Acquis monolingual dataset"
python prepare_jrc_data.py --languages "en" \
                           --save_path "datasets/jrc_en_basic.csv" \
                           --dataset_split $dataset_split

echo "Prepare JRC-Acquis multilingual dataset (English, French, German)"
python prepare_jrc_data.py --languages "en,de,fr" \
                            --save_path "datasets/jrc_3langs_basic.csv" \
                            --dataset_split $dataset_split

################# EURLEX57K ####################
echo "Download and prepare EURLEX57K dataset"
wget -nc -O tmp/datasets.zip http://nlp.cs.aueb.gr/software_and_datasets/EURLEX57K/datasets.zip
unzip tmp/datasets.zip -d tmp/EURLEX57K

python prepare_eurlex57k_data.py --dataset_path "./tmp/EURLEX57K/dataset/" --save_path "datasets/EurLex57K.csv"

echo "Delete tmp directory ..."
#rm -r tmp

echo "Done!"