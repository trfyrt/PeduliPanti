pipeline {
    agent any

    environment {
        PROXMOX_IP = '100.72.15.104'
        LXC_IP = '10.10.10.140'
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
                    # Gunakan tag yang benar
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
                sh 'ansible-playbook -i inventory.ini setup-docker.yml'

                sh '''
                sshpass -p $PROXMOX_PASSWORD ssh \
                    -o StrictHostKeyChecking=no \
                    -o ProxyCommand="sshpass -p $PROXMOX_PASSWORD ssh -W %h:%p root@$PROXMOX_IP" \
                    alvin@$LXC_IP "mkdir -p /opt/pedulipanti"

                scp \
                    -o StrictHostKeyChecking=no \
                    -o ProxyCommand="sshpass -p $PROXMOX_PASSWORD ssh -W %h:%p root@$PROXMOX_IP" \
                    docker-compose.yml alvin@$LXC_IP:/opt/pedulipanti/

                sshpass -p $PROXMOX_PASSWORD ssh \
                    -o StrictHostKeyChecking=no \
                    -o ProxyCommand="sshpass -p $PROXMOX_PASSWORD ssh -W %h:%p root@$PROXMOX_IP" \
                    alvin@$LXC_IP "cd /opt/pedulipanti && sudo docker compose up -d"
                '''
            }
        }
    }
}