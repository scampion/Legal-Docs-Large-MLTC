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


echo "Prepare JRC-Acquis monolingual dataset"
python prepare_jrc_data.py --languages "en" \
                           --save_path "datasets/jrc_en_basic.csv" \
                           --dataset_split $dataset_split

