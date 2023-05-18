# MySQL-and-Python
A small web app that allow users to create account, login, and make a bucket list.
This app is implemented using MySQL and Python. Copied from the tutorial http://code.tutsplus.com/tutorials/creating-a-web-app-from-scratch-using-python-flask-and-mysql--cms-22972
# MySQL-and-Python


### <font size=”15”> *Provision AWS Infrastructure using Terraform* </font>

- EC2 (for jenkins)
- EKS (for cluster)
- ECR ( two repo one for application and other for database)


## <font size=”20”> *you can run terraform with ansible by runnig the bash* </font>
```
$ chmod 400 bash.sh
```
```
bash bash.sh
```

 Commands to run terraform:
 ```
 $ cd terraform
 ```
 ```
 $ terraform init
 ```
 ```
 $ terraform apply --var-file vars.tfvars -auto-approve
 ```
 output:
 
 ![image](https://user-images.githubusercontent.com/71265897/226346888-f35d8a8a-0e50-4487-b0b8-415bc509d7f6.png)
 
 Take the jenkins-ip and replace it with inventory file:
 
 ![image](https://user-images.githubusercontent.com/71265897/226341875-ef93d82c-2fb3-4aff-97a5-f2c1f88b93d6.png)

## <font size=”20”> *Install jenkins and awscli kubectl using ansible * </font>

Commands to run terraform:
 ```
 $ cp jenkins_key.pem ../ansible/
 ```
 ```
 $ cd ../ansible/
 ```
 ```
 $ ansible-playbook -i inventory --private-key jenkins_key.pem web.yml
 ```
 output:
 
 copy the initial password and paste it when you open jenkins-ip:8080:
 
![image](https://user-images.githubusercontent.com/71265897/226349381-e6a1ef13-82f1-4167-96f7-e2bb7d308533.png)

### 1) choose install suggested plugins:
### 2) add github crediential:

![image](https://user-images.githubusercontent.com/71265897/226351880-e0beac02-8d9a-4d7d-b155-42d8447f4963.png)

### 3) add aws crediential as secret text:


![image](https://user-images.githubusercontent.com/71265897/226357043-8b0af7a7-6f23-4de0-957c-2a79ece98fbf.png)

![image](https://user-images.githubusercontent.com/71265897/226356456-5c245410-a9f5-436d-9acf-89ef6ba89e40.png)

### 4 )-	add webhook : http://18.206.236.164/:8080/github-webhook but replace by new instance ip and change Content type to application/json
 
### 5) add new  pipeline with any name you like:

![image](https://user-images.githubusercontent.com/71265897/226359938-93320756-65b8-4b3e-842a-761d8edaaae9.png)

![image](https://user-images.githubusercontent.com/71265897/226360299-581e2918-faec-439b-bd85-03dce771cf9e.png)

### 6) build the pipeline and open the url of load balancer


![image](https://user-images.githubusercontent.com/71265897/226381097-0d9dcb7f-311c-4cf1-b9ba-f45764165323.png)
