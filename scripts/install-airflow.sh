# https://towardsdatascience.com/getting-started-with-airflow-using-docker-cd8b44dbff98
wget https://raw.githubusercontent.com/dalvimanasi/Data-Pipe-lining-Tools/master/Airflow/AirflowDemo/Helloworld.py
sudo docker run -d -p 8080:8080 -v /home/user/:/usr/local/airflow/dags  puckel/docker-airflow webserver

# sudo docker exec -it edb5c3739482 bash
# airflow test Helloworld task_1 2015-06-01
# history | cut -c8-