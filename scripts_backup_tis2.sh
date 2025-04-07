#! /bin/bash


if [ -z "$1" ]; then
   exit
fi

if [ $USER != "$1" ]; then
    su - "$1" <<EOF
    pastaIP=\$(ip a | grep 10.140 | awk '{ print \$2 }' | cut -d'/' -f1 | cut -d'.' -f4)
    
    num=\$(echo \$pastaIP)
    arquivo=\$num"temp"\$(date +%d%m%Y_%H%M)
    caminho1="/mnt/psrmprodlogs/batchlogs/\$pastaIP"
    caminho2="/mnt/psrmprodlogs/batchlogs/\$pastaIP/\$arquivo"

    if [ -d /u01/sploutput/ ]; then

        Batch=/u01/sploutput/PSRM2.5
        mkdir -p \$caminho
        find \$Batch -type f \( -name "*.log*" -o -name "*.out*" \) -mtime +3 -exec rsync -avz --remove-source-files {} \$caminho2 \;
    else

        Batch=/u01/work/domain/
        mkdir -p \$caminho
        find \$Batch/*/servers/ -type f \( -name "*.log*" -o -name "*.out*" \) -mtime +3 -exec rsync -avz --remove-source-files {} \$caminho2 \;
    fi

    cd \$caminho1
    tar -czf \$arquivo.tar.gz \$arquivo
    rm -rf \$caminho2
EOF
exit
fi


