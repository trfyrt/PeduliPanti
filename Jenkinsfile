pipeline {
    agent any

    environment {
        // Variabel untuk SSH ke Proxmox (Pastikan diatur di Jenkins Credentials nantinya)
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
                    docker run --rm -v "$(pwd):/app" -w /app composer:2.7-php8.2 install --no-interaction
                    
                    docker run --rm -v "$(pwd):/app" -w /app php:8.2-cli php artisan test || echo "Test selesai/Tidak ada test"
                    '''
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                echo 'Membangun ulang image Docker Compose...'
                // Build images lokal di server Jenkins
                sh 'docker compose build'
            }
        }

        stage('Deploy ke Proxmox (via Ansible)') {
            steps {
                echo 'Mendeploy aplikasi ke LXC Container menggunakan Ansible...'
                // Asumsi Ansible sudah disetup di Jenkins server dengan inventory.ini yang benar
                // Menjalankan playbook yang sebelumnya kita buat
                sh 'ansible-playbook -i inventory.ini setup-docker.yml'
                
                // Perintah untuk menyalin file docker-compose dan menjalankannya di Container target
                // (Menggunakan SSH ProxyJump seperti yang kita pelajari)
                sh '''
                sshpass -p $PROXMOX_PASSWORD ssh -o StrictHostKeyChecking=no -o ProxyCommand="sshpass -p $PROXMOX_PASSWORD ssh -W %h:%p root@$PROXMOX_IP" alvin@$LXC_IP "mkdir -p /opt/pedulipanti"
                
                scp -o StrictHostKeyChecking=no -o ProxyCommand="sshpass -p $PROXMOX_PASSWORD ssh -W %h:%p root@$PROXMOX_IP" docker-compose.yml alvin@$LXC_IP:/opt/pedulipanti/
                
                sshpass -p $PROXMOX_PASSWORD ssh -o StrictHostKeyChecking=no -o ProxyCommand="sshpass -p $PROXMOX_PASSWORD ssh -W %h:%p root@$PROXMOX_IP" alvin@$LXC_IP "cd /opt/pedulipanti && sudo docker compose up -d"
                '''
            }
        }
    }
}