# Terraform-Modules

These modules are setup for terraform cloud based deployment and multi account deployment. 

To use these modules you must have terraform cloud free account atleast 

Set the workspaces on terraform cloud based upon the envoirnment. let say you have seperate account for staging and seperate account for prodcution so you have to create seperate workspaces with envoirnment tags. see the below image.

![alt text](https://github.com/rizwannadeem2017/terraform-modules/blob/main/image1.jpg?raw=true)

Set required variables and it's values on Terraform Cloud for example see below: becuase these values are not passed with this terraform modules and terraform workspace repo. 

region 
envoirnment
Access_key
Secret_key 

Terraform workspace repo can be look at : 

https://github.com/rizwannadeem2017/terraform-infra.git


Contact me at: linkedin.com/in/rizwannadeem007/