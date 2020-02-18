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

                                 mv $ec2sshfile  /var/lib/jenkins/workspace/devopsdaysmad-inspec-aws_master/src/terraform   

                                 mkdir -p /var/lib/jenkins/workspace/devopsdaysmad-inspec-aws_master/src/inspec/devopsdaysmad-aws/files

                                 terraform output --json >  /var/lib/jenkins/workspace/devopsdaysmad-inspec-aws_master/src/inspec/devopsdaysmad-aws/files/terraform.json
                              '''
                           }
                    }
                 }
                 }

                stage('Inspec-nginx') {
                        steps {
                             dir("${env.WORKSPACE}/src/terraform"){    
                                script {
                                    myVar = terraform output aws_ec2_public_address
                                }       

                              echo "${myVar}" // prints 'initial_value'
                              sh 'echo terraform output aws_ec2_public_address > myfile.txt'
                              script {
                                 // OPTION 1: set variable by reading from file.
                                 // FYI, trim removes leading and trailing whitespace from the string
                                 myVar = readFile('myfile.txt').trim()

                              }
                              echo "${myVar}" // prints 'hotness'                                                                                 
                           }                      
                        }
                    }

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