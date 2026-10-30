pipeline {
    agent any
    options { timestamps(); disableConcurrentBuilds() }
    environment {
        TF_DIR = 'terraform'
        SSH_CREDENTIAL_ID = 'web-server-ssh-key'
    }
    stages {
        stage('Checkout') { steps { checkout scm } }
        stage('Terraform Validate') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform init -input=false'
                    sh 'terraform fmt -check -recursive'
                    sh 'terraform validate'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform plan -input=false -out=tfplan'
                    sh 'terraform show tfplan'
                }
            }
        }
        stage('Approval') {
            steps { input message: 'Review the plan. Apply these AWS changes?', ok: 'Apply' }
        }
        stage('Terraform Apply') {
            steps {
                dir("${TF_DIR}") { sh 'terraform apply -input=false -auto-approve tfplan' }
            }
        }
        stage('Configure Web Server') {
            steps {
                script {
                    def ip = sh(script: "cd ${TF_DIR} && terraform output -raw public_ip", returnStdout: true).trim()
                    writeFile file: 'ansible/inventory.ini',
                        text: "[web]\n${ip} ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3\n"
                    sshagent(credentials: [env.SSH_CREDENTIAL_ID]) {
                        sh 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/inventory.ini ansible/site.yml'
                    }
                }
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'terraform/*.tfplan, ansible/inventory.ini', allowEmptyArchive: true
        }
    }
}
