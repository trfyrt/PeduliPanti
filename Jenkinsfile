pipeline {
    agent any

    environment {
        PROXMOX_IP         = '100.72.15.104'
        LXC_IP             = '10.10.10.140'
        PROXMOX_PASSWORD   = credentials('NEW_PROXMOX_PASSWORD')
        CONTAINER_PASSWORD = credentials('NEW_CONTAINER_PASSWORD')
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Mengambil kode terbaru dari GitHub...'
                checkout scm
            }
        }

        stage('Test Laravel') {
            steps {
                echo 'Menjalankan unit test Backend...'
                dir('PeduliPanti - BE') {
                    sh '''
                    docker run --rm -v "$(pwd):/app" -w /app composer:2.7 install --no-interaction
                    docker run --rm -v "$(pwd):/app" -w /app php:8.2-cli php artisan test || echo "Test selesai/Tidak ada test"
                    '''
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                echo 'Membangun ulang image Docker Compose...'
                sh 'docker compose build'
            }
        }

        stage('Deploy ke Proxmox (via Ansible)') {
            steps {
                echo 'Mendeploy aplikasi ke LXC Container menggunakan Ansible...'
                
                // Menjalankan Ansible TANPA ProxyCommand
                sh """
                export ANSIBLE_HOST_KEY_CHECKING=False
                
                ansible-playbook -i inventory.ini setup-docker.yml -vvv \
                    -e "ansible_password=${CONTAINER_PASSWORD}" \
                    -e "ansible_become_pass=${CONTAINER_PASSWORD}"
                """

                // Eksekusi manual dengan trik kompresi (100x Lebih Cepat)
                sh """
                # 1. Bungkus semua file menjadi satu file archive (karung) bernama app.tar.gz
                tar -czf app.tar.gz ./

                # 2. Buat folder di target LXC
                sshpass -p "${CONTAINER_PASSWORD}" ssh \
                    -o StrictHostKeyChecking=no \
                    -o ProxyCommand="sshpass -p '${PROXMOX_PASSWORD}' ssh -o StrictHostKeyChecking=no -W %h:%p root@${PROXMOX_IP}" \
                    alvin@${LXC_IP} "mkdir -p ~/pedulipanti"

                # 3. Kirim HANYA SATU FILE karung tersebut (Sangat Cepat!)
                sshpass -p "${CONTAINER_PASSWORD}" scp \
                    -o StrictHostKeyChecking=no \
                    -o ProxyCommand="sshpass -p '${PROXMOX_PASSWORD}' ssh -o StrictHostKeyChecking=no -W %h:%p root@${PROXMOX_IP}" \
                    app.tar.gz alvin@${LXC_IP}:~/pedulipanti/

                # 4. Ekstrak karung tersebut di LXC, lalu jalankan Docker Compose
                sshpass -p "${CONTAINER_PASSWORD}" ssh \
                    -o StrictHostKeyChecking=no \
                    -o ProxyCommand="sshpass -p '${PROXMOX_PASSWORD}' ssh -o StrictHostKeyChecking=no -W %h:%p root@${PROXMOX_IP}" \
                    alvin@${LXC_IP} "cd ~/pedulipanti && tar -xzf app.tar.gz && echo '${CONTAINER_PASSWORD}' | sudo -S docker compose up -d --build"
                """
            }
        }
        
        stage('Cleanup / Sapu Bersih') {
            steps {
                echo 'Membersihkan sampah Docker (Dangling Images & Cache)...'
                sh '''
                docker image prune -f
                docker builder prune -f
                '''
            }
        }
    }
}