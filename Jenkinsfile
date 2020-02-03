pipeline {
         agent any
         stages {
                 stage('Download Profile') {
                 steps {
                     echo 'App of aws'
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
