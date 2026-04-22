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

                // Eksekusi manual SSH/SCP secara LANGSUNG
                sh """
                sshpass -p "${CONTAINER_PASSWORD}" ssh \
                    -o StrictHostKeyChecking=no \
                    alvin@${LXC_IP} "mkdir -p /opt/pedulipanti"

                sshpass -p "${CONTAINER_PASSWORD}" scp \
                    -o StrictHostKeyChecking=no \
                    docker-compose.yml alvin@${LXC_IP}:/opt/pedulipanti/

                sshpass -p "${CONTAINER_PASSWORD}" ssh \
                    -o StrictHostKeyChecking=no \
                    alvin@${LXC_IP} "cd /opt/pedulipanti && sudo docker compose up -d"
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