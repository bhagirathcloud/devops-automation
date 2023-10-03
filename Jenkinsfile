pipeline {
         agent any
         stages {
                 stage('One') {
                 steps {
                     echo 'Hi, this is bhagi from edureka and welcome you to devops class 2023'
                 }
                 }
                 stage('Two') {
                 steps {
                    input('Do you want to proceed?')
                 }
                 }
                 stage('Three') {
                 when {
                       not {
                            branch "master"
                       }
                 }
                 steps {
                       echo "Hello"
                 }
                 }
             
}
}
