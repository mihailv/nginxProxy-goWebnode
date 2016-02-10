# Nginx proxy -- multiple go webnodes
1lb -- 1-n go webnodes 

## Installing
### vagrant
* prerequisites:
    * vagrant
* git clone https://github.com/mihailv/nginxProxy-goWebnode.git && cd nginxProxy-goWebnode && **vagrant up**

## Default
Will create (3)
* 2 web nodes **web1 - 10.0.0.10 web2 - 10.0.0.11 LISTEN 8484** on a private network
    * Will install the webserver from **github.com/mihailv/web/sgo_webserver**
    * will create an init script **/etc/init.d/sgo_webserver**
* 1 nginx loadbalancer **lb1 10.0.0.12 LISTEN 80**

## Parameters
Global:
* company : system path identifier

Golang webserver source code:
* repo : github repository
* namespace : folder in repository
* app : application name

Balancing:
* lb_ip : loadbalancer ip
* webnode_ips : round robin ips
* webnode_port : golang webserver LISTEN port

## Provisioning (/puppet/manifests)
Loadbalancer node *lb.pp* :
* installs the nginx webserver
* based on the $webnode_ips variable from the Vagrant file will define the round-robin rule in nginx

Web nodes *webnodes.pp*:
* golang install: will install the go binary **/opt/$company**
* golang app: will install the Golang webserver **go get $repo/$namespace/$app**
    * will install an init script **/etc/init.d/$app**

## Scalling
To increse the number of web nodes 
* add to the $webnode_ips another ip in the Vagrant file 
* reprovision the load balancer **vagrant provision lb1**

## Testing
On lb1 the webserver **LISTEN**s on **80**  - will return round robined responses from go webservers
```
vagrant@lb1:~$ curl http://localhost
Hi there, I'm served from web1!
vagrant@lb1:~$ curl http://localhost
Hi there, I'm served from web2!
vagrant@lb1:~$ curl http://localhost
Hi there, I'm served from web1!
```
