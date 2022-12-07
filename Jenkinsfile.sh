pipeline {
  agent any
   stages {
    stage ('Build') {
      steps {
        sh '''#!/bin/bash
        chmod+x updatedscript.sh
       source venv/bin/activate
       python -m pip install Django
       source venv/bin/activate
       source /path/to/venv/bin/activate
       python -m pip install gunicorn
       python -m pip install requests
       pip install dj-database-url
       pip3 install psycopg2
       pip install pillow
       pip3 install -r requirements.txt
        '''
     }
   }
    stage ('test') {
      steps {
        sh '''#!/bin/bash
        source venv/bin/activate
        '''
      } 
    }
   }
}