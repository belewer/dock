pipeline {
    agent {
        kubernetes {
            yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          serviceAccount: jenkinsci
          containers:
          - name: jdk
            image: openjdk:17-jdk-alpine3.14
            command:
            - cat
            tty: true
          - name: lint
            image: nvuillam/npm-groovy-lint
            command:
            - cat
            tty: true
          - name: helm
            image: alpine/helm
            command:
            - cat
            tty: true
          - name: docker
            image: docker:20.10.24-alpine3.18
            command:
            - cat
            tty: true
            volumeMounts:
             - mountPath: /var/run/docker.sock
               name: docker-sock
          volumes:
          - name: docker-sock
            hostPath:
              path: /var/run/docker.sock
        '''
        }
    }

    stages {
    // stage('Install') {
    //   steps {
    //     container('jdk') {
    //       sh 'sh gradlew build'
    //     }
    //   }
    // }

        stage('Audit') {
            steps {
                container('jdk') {
                    sh 'sh gradlew check'
                }
            }
        }

        stage('Lint') {
            steps {
                container('lint') {
                    sh '''
                        npm-groovy-lint src
                    '''
                }
            }
        }

        stage('Test') {
            steps {
                container('jdk') {
                    sh 'sh gradlew test'
                }
            }
        }

        stage('Build') {
            steps {
                container('docker') {
                    script {
                        env.VERSION = sh(returnStdout: true, script: "cat build.gradle | grep 'version =' | sed -e 's/version = //' | sed -e s\"/'//\"g")
                        sh 'docker build -t dock:\$VERSION .'
                    }
                }
            }
        }

        stage('Publish') {
            steps {
                container('docker') {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh '''
                    docker login -u $USER -p $PASS
                    docker tag dock:\$VERSION jovilon/dock:\$VERSION
                    docker push jovilon/dock:\$VERSION
                '''
                    }
                }
            }
        }

    // stage('Deploy') {
    //   steps {
    //     container('helm') {
    //       sh '''
    //         helm repo add postgresql https://charts.bitnami.com/bitnami
    //         helm repo update
    //         helm dependency build charts/pepe-project/
    //         helm upgrade --install pepe-project charts/pepe-project/ -f charts/pepe-project/values.yaml -n apps
    //       '''
    //     }
    //   }
    // }
    }
}
