# https://towardsdatascience.com/getting-started-with-airflow-using-docker-cd8b44dbff98
# https://medium.com/google-cloud/apache-airflow-how-to-add-a-connection-to-google-cloud-with-cli-af2cc8df138d

git clone https://github.com/ibrezm1/test-airflow.git
cd test-airflow
mv /tmp/keys/gcp*.json /tmp/keys/key.json
sudo docker run --name airflowapp \
            -d -p 8080:8080 \
            -v $(pwd):/usr/local/airflow/dags  \
            -v /tmp/keys/:/tmp/keys \
            puckel/docker-airflow webserver

# sudo docker exec -it airflowapp bash
# airflow test Helloworld task_1 2015-06-01
# history | cut -c8-