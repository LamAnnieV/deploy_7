**GIT - update datapoints**

```
git clone https://github.com/LamAnnieV/deploy_7.git
cd deploy_7/
git init
git branch second
git switch second
#Update Database_URL in app.py, database.py, and load_data.py
git commit -a
```

**GIT - docker file**

```
#update dockerfile
git commit -a #added comment
#Test the docker file
#Build the image
docker build -t bankapp
#create the container and deploy the application
docker container run -p 80:8000 bankapp
#Retag an image to include the Docker Hub account name
docker tag bankapp annievlam/banking
login into docker hub on your terminal
docker login #enter credentials
#Push the image to docker hub
docker push annievlam/bankapp
#Delete image from Docker Hub
```
**GIT - Jenkins-Agent Infrastructure**

```
#Make a new directory jenkinsTerraform
git add jenkinsTerraform
#Create files main.tf, terraform.tfvars, variables.tf, installs1.sh, installs2.sh, installs3.sh
terraform init
terraform validate
terraform plan
terraform apply
#After the successful creation of the Jenkins Agent infrastructure
git add main.tf terraform.tfvars variables.tf installs1.sh installs2.sh installs3.sh
git commit -a
#make a file .gitignore and put all the names of the files for git to ignore
git push --set-upstream origin second
git switch main
git merge second
git push --all
```

**GIT - initTerraform**

```
git switch second
#Update .tf files
git commit -a
git switch main
get merge second
git push --all
```





