#! /bin/bash

if [ -z "$1" ]; then
   exit
fi

if [ $USER != "$1" ]; then
    su - "$1" <<EOF

    pastaIP=\$(ip a | grep 127 | awk '{ print \$2 }' | cut -d'/' -f1 | cut -d'.' -f4)
    num=\$(echo \$pastaIP)
    arquivo=\$num"temp"\$(date +%d%m%Y_%H%M)
    caminho1="/mnt/psrmprodlogs/batchlogs/\$pastaIP"
    caminho2="/mnt/psrmprodlogs/batchlogs/\$pastaIP/\$arquivo"

    if [ -d /mnt/sploutput/ ]; then

        Batch=/mnt/sploutput/PSRM2.5
        mkdir -p \$caminho2
        find \$Batch -type f \( -name "*.mp4" -o -name "FDownloader*" \) -mtime +2 -exec rsync -avz --remove-source-files {} \$caminho2 \;
    else

        Batch=/mnt/work/domain/
        mkdir -p \$caminho2
        find \$Batch/*/server/ -type f \( -name "*.mp4" -o -name "FDownloader*" \) -mtime +2 -exec rsync -avz --remove-source-files {} \$caminho2 \;
    fi

    cd \$caminho1
    tar -czf \$arquivo.tar.gz \$arquivo
    rm -rf \$caminho2
EOF
echo "ola"
fi


