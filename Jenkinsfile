pipeline {
         agent any
         environment {
               AWS_DEFAULT_REGION    = credentials('AWS_DEFAULT_REGION')
               AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
               AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
         }
         stages {
                 stage('Build terraform') {
                    steps {
                          dir("${env.WORKSPACE}/src/terraform"){
                              sh "terraform init"
                           }

                           withCredentials([file(credentialsId: 'aws-ec2-sshkey', variable: 'aws-ec2-sshkey')]) {
                            dir("${env.WORKSPACE}/src/terraform"){
                              sh 'cat $tfvars'
                              sh'terraform plan -var=ssh_privatekey=$aws-ec2-sshkey'
                              sh'terraform apply -var=ssh_privatekey=$aws-ec2-sshkey'
                           }
                    }
                 }
                 stage('Test') {
                 steps {
                    sh 'inspec exec https://github.com/dev-sec/linux-baseline --reporter cli junit:testresults.xml'
                 }
                 }
                 stage('Prod') {
                     steps {
                                echo "App is Prod Ready"
                              }
                 }
                }
         post {
        always {
            junit 'testresults.xml'
        }
               }
          }
