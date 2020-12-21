pipeline {
  agent any
  parameters {
    string(name: 'APP', defaultValue: 'back', description: 'Waypoint project application')
    string(name: 'WAYPOINT_SERVER', defaultValue: '10.110.80.222:9701', description: 'Waypoint server address')
  }
  environment {
    WAYPOINT_VERSION = '0.1.5'
    WAYPOINT_SERVER_ADDR = "${params.WAYPOINT_SERVER}"
    WAYPOINT_SERVER_TOKEN = credentials('vault-waypoint-token')
    WAYPOINT_SERVER_TLS = '1'
    WAYPOINT_SERVER_TLS_SKIP_VERIFY = '1'
  }
  stages {
    stage('Prep-Env'){
      steps {
        git credentialsId: 'gitlab-dcanadillas-token', url: 'https://gitlab.com/dcanadillas/bk8s-demo'
        sh 'ls'
        sh 'curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"'  
        sh 'chmod u+x ./kubectl'
        sh 'curl -s -o waypoint.zip https://releases.hashicorp.com/waypoint/0.1.5/waypoint_0.1.5_linux_amd64.zip'
        sh 'unzip -o waypoint.zip'
        sh 'chmod u+x ./waypoint'
        withCredentials([file(credentialsId: 'key-owner-hc-dcanadillas', variable: 'GCP_KEY')]){
          sh '''
            chmod 600 $GCP_KEY
            cat $GCP_KEY | docker login -u _json_key --password-stdin https://gcr.io
          '''
        }
      }
    }
    stage('Build') {
      steps {
        sh './waypoint init'
        sh "./waypoint build -app ${params.APP}"
      }
    }
    stage('Pre-Deploy') {
      steps {
        withKubeConfig([credentialsId: 'minikube', serverUrl: 'https://192.168.64.11:8443']) {
          sh '''
          cat <<EOF | ./kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: "apps"
EOF
          '''
        }
      }
    }
    stage('Deploy') {
      steps {
        withKubeConfig([credentialsId: 'minikube', serverUrl: 'https://192.168.64.11:8443']) {
          sh './kubectl get ns'
          sh "./waypoint deploy -app ${params.APP}"
        }
      }
    }
    stage('Release') {
      steps {
        withKubeConfig([credentialsId: 'minikube', serverUrl: 'https://192.168.64.11:8443']) {
          sh './kubectl get ns'
          sh "./waypoint release -app ${params.APP}"
        }
      }
    }
  }
}