# Terraform-Modules

These modules are setup for terraform cloud based deployment and multi account deployment. 

To use these modules you must have terraform cloud free account atleast. 

Set the workspaces on terraform cloud based upon the envoirnment. let say you have seperate account for staging and seperate account for prodcution so you have to create seperate workspaces with envoirnment tags. see the below image.


Set required variables on each workspace on Terraform Cloud for example see below: becuase these values are sensitive so not to pass within this terraform modules and terraform workspace repo. 

![alt text](https://github.com/rizwannadeem2017/terraform-modules/blob/main/image1.jpg?raw=true)

* Region 
* Envoirnment
* Access_key
* Secret_key 

Terraform workspace repo can be look at: 

https://github.com/rizwannadeem2017/terraform-infra.git


Contact me at: linkedin.com/in/rizwannadeem007/