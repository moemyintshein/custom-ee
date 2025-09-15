# Creating custom ansible execution environment

### Clone repo and create python virtual environment

$ git clone https://github.com/moemyintshein/custom-ee.git
$ cd custom-ee/
$ python3 -m venv venv  #create virtual env
$ source venv/bin/activate  #activate virtual env
$ pip install ansible ansible-builder   #install ansible-core and ansible-builder
$ ansible-builder build --tag custom-ee:latest  #build image with tag latest
$ podman images
$ podman run --rm -it localhost/custom-ee:latest ansible-galaxy collection list   #you can check galaxy collection list in builded images
$ podman run -it localhost/custom-ee:latest /bin/bash 	#To check xml module in image ( #ansible-doc xml )

### Export builded image to tar
$ podman tag {IMAGE ID} custom-ee:latest		#Change the image name an tag (optional)
$ podman save localhost/customee-ee -o custom-ee.tar		#Save image and will export custom-ee.tar

### To use this image in Oracle Linux Automation Manager
$ scp custom-ee.tar user@192.168.128.100:/tmp/  #upload image to Oracle Linux Automation Manager installed server
$ ssh user@192.168.128.100
$ su -l awx -s /bin/bash                    #To change user
$ podman load -i /tmp/general-ee.tar		#Load image to container images

And then you can use this custom execution environment in Oracle Linux Automation Manager

