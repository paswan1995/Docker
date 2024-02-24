## Docker 5

## How Isolations are created or How Containers Works

* Each container is getting a
       *  new proccess tree
       *  disk mounts 
       *  network (nic)
       *  cpu/memory
       *  users

## Docker Internals 

* ![preview](images/44.png)

* Lets Start From Container
   * Container can be defined as isolation with some resource limits 
  
   * ![preview](images/34.png)
    
   * So, host system can create multiple different containers 

   * ![preview](images/35.png)

## How are Isolations Created & Resource Limits Applied ?

* Isolations on the linux machines are created using a linux kernel feature called Namespaces. for more info Click Here: https://en.wikipedia.org/wiki/Linux_namespaces

* Resource Limits are applied using kernel feature called as cgroups (Control groups). For more info Click Here: https://en.wikipedia.org/wiki/Cgroups

* ![preview](images/36.png)

* Working on namespaces & cgroups are difficult, but here comes the docker to the rescue.   
* Docker Engine makes it easy to create isolated areas & resource limits

* ![preview](images/37.png)

* ## Namespaces

 * Namespaces is a linux feature.
 * There is an interesting article on namespaces over here: https://www.toptal.com/linux/separation-anxiety-isolating-your-system-with-linux-namespaces

 * you can skip code & look at images
     * To be very specific,
     * __pID__ namespace (Process Namespace) creates the isolated process tree inside container 

* ![preview](images/38.png)

* __net__ namespace (Network Namespace) creates the isolated networking for each container with its own network interface.

* ![preview](images/39.png)

* __mount__ namespace creation allows each container to have a different view of entire systems mount point, this allows containers to have their own file system view which starts from root 

* ![preview](images/40.png)

* __user__ namespace allows to create whole new set of user & groups for the containers
  
* Fortunately even in windows world we have namespaces now. The purpose of the namespace is same but underlying implementation differs. Refer this article: https://learn.microsoft.com/en-us/archive/msdn-magazine/2017/april/containers-bringing-docker-to-windows-developers-with-windows-server-containers

* ## cgroups (control groups)

* cgroups (control groups) is a linux kernel feature
* Control groups is used to impose limits. We can impose limits of disk io, RAM & cpu’s using ControlGroups
* Fortunately even in windows world we have control groups now. The purpose of the namespace is same but underlying implementation differs. Refer this article: https://learn.microsoft.com/en-us/archive/msdn-magazine/2017/april/containers-bringing-docker-to-windows-developers-with-windows-server-containers

* ## Containers also have Layers for Filesystems

* ## Docker Underlying Components

* The underlying components of docker as per the latest implementation is looking as shown

* ![preview](images/41.png)

* The Specific Linux Implementation will be shown below

* ![preview](images/42.png)

* The Specific Windows Implementation will be as shown below

* ![preview](images/43.png)

* ## Docker Architecture

* ## Generation 1:
     
     * This was first gen, Where docker daemon used lxc (a linux kernel feature) to create containers
     
     * ![preview](images/45.png)

* ## Generation2:
   
    * Since docker was relying on lxc which was kernel feature, updates to kernel frequently used to break containers created by docker.
    * So docker has created its own component called libcontainer (libc) to create containers.
    * Docker wanted containers to be multi os and lxc was definetly not the way forward.

* ![preview](images/46.png)

* Adoption of docker was drastically increased as it was stable.

* ## Generation 3:

   * In this generation, docker engine was revamped from monolith to multi component architecture and the images and containers were according to OCI (open container initiative) image spec and runtime spec.
   * In the latest architecture
   * docker daemon exposes api’s to listen requests from docker client.
   * Passes the requests to containerd. This manages the lifecylcle of container
   * containerd forks a runc process which creates container. once the container is created the parent of the container will be docker shim  

* __libc uses directly linux api to speak kernel directly__
* __forks means creating new process runc__
* __docker shim report all the msgs to containerd__
* __exec means creating new process runc and its kill itself__
* __Rejistry where is docker images__
* __ContainerC --> images --> create --> Deamon --> ContainerD speak with runc__.
* ![preview](images/47.png)

* ## Creating our first docker container

* docker container creation:
* To create container we need some image in this case lets take `hello-world`
* The command `docker container run hello-world` executed
* What happens
   * docker client will forward the request to docker daemon
   * docker daemon will check if the image exists locally. if yes creates the container by using image
   * if the image doesnot exist, then docker daemon tries to download the image from docker registry connected.
   * The default docker registry is docker hub
   * Downloading image into local repo from registy is called as pull.
   * Once the image is pulled the container is created.

* ![preview](images/48.png)

* Registry is collection of docker images hosted for reuse.
* Docker hub Refer Here: https://hub.docker.com/search?q=

* Playing with containers

* Create a new linux vm and install docker in it

![preview](images/49.png)

* whatever you want to kmow about commands you should use always `docker --help , docker image --help , docker container --help `
   
![preview](images/50.png)
![preview](images/51.png)
![preview](images/52.png)

* ## pull the images from docker hub
  
* __image naming convention__
    
```
[username]/[repository]:[<tag>]
shaikkhajaibrahim/myspc:1.0.1
username => shaikkhajaibrahim
repository => what image => myspc
tag => version => 1.0.1

```

* __default tag is latest__

`nginx` 
`nginx:latest`

* __official images dont have username__
  
```
nginx
ubuntu
alpine
shaikkhajaibrahim/myspc

```

* __Lets pull the image nginx with tag `1.24`__
* ![preview](images/53.png)
* ![preview](images/54.png)

* __Lets pull the jenkins image with latest version__

![preview](images/55.png)
* __Lets find the alpine and pull the image__
![preview](images/56.png)

## Remove images from local

* Every image will have unique image id and image name
* We can delete individually `docker image rm alpine:3.19.1` 
* if i have to delete all the images `docker image rm $(docker image ls -q)`
* ![preview](images/57.png)
* ![preview](images/58.png)

## Create a container with nginx

* To create and start the container we use run command
* ![preview](images/59.png)
* note: i will be using -d for some time and we will discuss importance of this in next session
* every container gets an id and a name. name can be passed while creating container, if not docker will give random name.
* ![preview](images/60.png)

* ## Remove all the running containers
* `docker container rm -f $(docker container ls -q)`
* ![preview](images/61.png)

* ## Remove specific container
* ![preview](images/62.png)

* ## How to start a Docker container 

* To run a simple container based on the Ubuntu image we just pulled, run the command below: 
* ![preview](images/63.png)
* `docker run -it ubuntu /bin/bash`

* After running the container, you’ll be inside the container’s shell (in this example, a Bash shell). You can interact with it just like a regular Linux system.
* When you’re done, you can exit the container by typing exit.
* Let’s take a look at the command options for docker run.
* This command is used to start a container, and the syntax looks like this:
* `docker run [OPTIONS] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...] `
* The IMAGE we used was ubuntu , the `-it` OPTIONS we specified make the container interactive and allocate a terminal. The COMMAND we supplied was the command to run inside the terminal of the running container.
* refer: https://docs.docker.com/engine/reference/run/
* start and stop containers `docker start 4d3dfee4a8e6/nginx1 or stop docker stop 4d3dfee4a8e4/nginx2`
* ![preview](images/64.png)
* ![preview](images/65.png)

##