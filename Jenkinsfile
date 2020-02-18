myVar = 'initial_value'

pipeline {
         agent any
         environment {
               AWS_DEFAULT_REGION    = credentials('AWS_DEFAULT_REGION')
               AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
               AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
         }
         stages {
                 stage('Build Terraform') {
                    steps {
                          dir("${env.WORKSPACE}/src/terraform"){
                              sh "terraform init"
                           }

                           withCredentials([file(credentialsId: 'ec2sshfile', variable: 'ec2sshfile')]) {
                            dir("${env.WORKSPACE}/src/terraform"){
                              sh'''
                                 terraform plan -var=ssh_privatekey=$ec2sshfile
                                 terraform apply -var=ssh_privatekey=$ec2sshfile -auto-approve 

                                 mv $ec2sshfile  /var/lib/jenkins/workspace/devopsdaysmad-inspec-aws_master/src/ansible   

                                 mkdir -p /var/lib/jenkins/workspace/devopsdaysmad-inspec-aws_master/src/inspec/devopsdaysmad-aws/files

                                 terraform output --json >  /var/lib/jenkins/workspace/devopsdaysmad-inspec-aws_master/src/inspec/devopsdaysmad-aws/files/terraform.json

                                 terraform output aws_ec2_public_address > myfile.txt

                              '''

                               script {
                                 env.alex = readFile('myfile.txt').trim() 
                               }
                           }
                    }
                 }
                 }

                 stage('Ansible') {
                    steps {                        
                           withCredentials([file(credentialsId: 'ec2sshfile', variable: 'ec2sshfile')]) {
                            dir("${env.WORKSPACE}/src/ansible"){
                              sh'''
                                 echo "[all]" >> inventory
                                 echo "${alex}" >> inventory

                                 cat inventory

                                 ANSIBLE_HOST_KEY_CHECKING=False
                                 ansible-playbook -u ubuntu --private-key alex.pem playbook.yml -i ${alex} -b
                              '''
                           }
                    }
                 }
                 }

                  /*
                stage('inspec nginx') {
                        steps {
                           catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {  
                             dir("${env.WORKSPACE}/src/terraform"){    

                              echo "${myVar}" // prints 'initial_value'
                              sh 'terraform output aws_ec2_public_address > myfile.txt'
                              script {
                                 myVar = readFile('myfile.txt').trim()

                                 env.alex = readFile('myfile.txt').trim() 

                              }
                              echo "${myVar}" // prints 'hotness'

                              sh'''
                                  inspec exec https://github.com/dev-sec/nginx-baseline.git --key-files alex.pem --target ssh://ubuntu@${alex} --reporter cli junit:testresults-nginx.xml json:results-nginx.json
                              '''                                                                                   
                           }
                           }                      
                        }
                    }

                    */

                 stage('Inspec Tests') {
                 steps {
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {                    
                         dir("${env.WORKSPACE}/src/inspec/devopsdaysmad-aws"){
                              sh '''
                                 inspec exec . -t aws:// --reporter cli junit:testresults.xml json:results.json
                              '''
                           }
                    }
                 }
                 }
                  stage('Upload tests to grafana') {
                        steps {
                             dir("${env.WORKSPACE}/src/inspec/devopsdaysmad-aws"){                                   
                                   sh '''
                                        ls
                                        curl -F 'file=@results.json' -F 'platform=aws-terraform' http://localhost:5001/api/InspecResults/Upload
                                   '''                                   
                           }
                             dir("${env.WORKSPACE}/src/terraform"){                                   
                                   sh '''
                                        ls
                                           curl -F 'file=@results-nginx.json' -F 'platform=aws-ec2-nginx' http://localhost:5001/api/InspecResults/Upload
                                   '''                                   
                           }                      
                        }
                    }
                     /*
                   stage('Delete Infra') {
                    steps {
                           withCredentials([file(credentialsId: 'ec2sshfile', variable: 'ec2sshfile')]) {
                            dir("${env.WORKSPACE}/src/terraform"){
                              sh'''
                                 terraform destroy -var=ssh_privatekey=$ec2sshfile -auto-approve                                 
                              '''
                                    }
                           }
                        }
                 }
                 */
                }
         post {
        always {
            junit '**/src/**/*.xml'
        }
               }
}