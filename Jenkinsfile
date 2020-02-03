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
                    sh 'inspec exec https://github.com/dev-sec/nginx-baseline --reporter cli junit:artifacts/testresults.xml'
                 }
                 }
                 stage('Prod') {
                     steps {
                                echo "App is Prod Ready"
                              }
                 }
                }
          }
