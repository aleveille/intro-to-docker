# Welcome

This hands-on guide assumes that you've already read or heard about Docker and are ready to try it out. This guide is intended for complete beginners and will, therefore, explain every command that is being run and the options used.

Note: if you don't know anything about Docker, the following two resources should get you started:

* ["What is Docker?"](https://www.docker.com/what-docker) _Docker, Inc._
* ["Docker Explained: Using Dockerfiles to Automate Building of Images"](https://www.digitalocean.com/community/tutorials/docker-explained-using-dockerfiles-to-automate-building-of-images) _Digital Ocean_

Before going any further, make sure you have Docker for Mac installed on your machine.

## Step 1 - Hello world

We'll start with Docker's simple "Hello, world" container. In order to run that container, simply type the command below:

```shell
docker run --name step1-helloworld hello-world
```

This will pull (download) the `hello-world` image, create and run container from that image. The container will then output something like what's shown below and exit.

```shell
Hello from Docker.
This message shows that your installation appears to be working correctly.
...
```

Note that we provided the `--name step1-helloworld` option. When not provided by a name, Docker will automatically generate a random name when you start a container. Providing the `--name` option makes it easier to find your containers later on.

After the `--name` option and its value is the image name: `hello-world`. This image [from an official repository](https://hub.docker.com/_/hello-world/), so we don't need to specify who the provider is or where the image is stored.

The command to query the list of containers is:

```shell
docker ps
```

However, this command only shows the running containers by default and as mentioned earlier, this hello-world from Docker just outputs some information and exits right away. Turns out there's a flag that you can use to query all the containers, no matter their state:

```shell
docker ps -a
```

Which should give you an output similar to:

```shell
CONTAINER ID        IMAGE                                                                    COMMAND                   CREATED             STATUS                     PORTS               NAMES
13e348f16471        hello-world                                                              "/hello"                  2 minutes ago       Exited (0) 2 minutes ago                       step1-helloworld
```

There're a few interesting things in there. First, the "Container ID". This string is actually the short version of the full container ID which is made of 64 hexadecimal characters.

Next, you have the "Image" name. This matches, not surprisingly, the image name we supplied earlier when we did the `docker run`.

Then there's the "Command". This is the shell command invoked when the container starts up. In this case, it ran some executable script named "hello" which is located at the root of the filesystem (therefore :/hello).

Following the command, they're the "Created" and "Status" columns which will tell you, respectively, when this container was created and it's status (which can be [running, exited some time ago, paused, etc](https://docs.docker.com/engine/reference/commandline/ps/#status)).

The "Ports" column will show you which port are available, if they are mapped to the host and if so, on which interface.

Finally, there's the "Name" which, again, matches what we provided earlier via the `--name` option (how convenient!)

Now that we have examined the output of "docker ps" quite a bit, let's do a bit of housekeeping and remove that container since, really, it's quite useless:
```
docker rm step1-helloworld
```

Now if you run the `docker ps -a` again, you will see that the container was removed from your system.

However, when we ran `docker run ...`, I mentioned that Docker _pulls_ the hello-world image and then created and ran container from that image.

It turns out that `docker rm` only deletes the container. And there's a good reason to that. A single image can be used to run many many containers. So, by default, when you remove a container, its image stays on your system.

_Note: if you want, you can try to run the "docker run" command again. You'll see that Docker doesn't need to download the image this time. Just remember to delete the container again before continuing to the next step._

To inspect the images on your system, use the "docker images" command:

```shell
docker images
```

This command will output the repository (which is really the repository+name of the image), the tag of the image, its unique and immutable ID, when that image was created and the size of the image.

Yep, the hello-world image is under 1KB. That's pretty impressive (but then again, it doesn't do much.)

It's good practice to remove images you don't need anymore every now and then. Of course, the hello-world image is super small so there's no real pressure to remove it, but let's practice removing an image while we're still learning the fundamentals:

```shell
docker rmi hello-world
```

### Step 1 summary

In this step, we used docker run to run a container. The Docker engine, behind the scene, first downloaded the image which is the basis of the container and then created and finally ran the container.

We then saw the basic commands to list and remove containers and images.

## Step 2

Let's start doing something more meaningful. Instead of using a black-box hello-world image, we'll use a NodeJS image to start a web server that will serve a "Hello, world" type of response. We will later extend on that server.

First, in your working directory, create an app.js file with the following content:

```javascript
// Shamelessly grabbed from https://howtonode.org/hello-node

// Load the http module to create an http server.
var http = require('http');

// Configure our HTTP server to respond with Hello World to all requests.
var server = http.createServer(function (request, response) {
  response.writeHead(200, {"Content-Type": "text/plain"});
  response.end("Hello World\n");
});

// Listen on port 8000, IP defaults to 127.0.0.1
server.listen(8000);

// Put a friendly message on the terminal
console.log("Server running at http://127.0.0.1:8000/");
```

Then, in the same directory, run the following docker run command:

```shell
docker run -d \
    --name step2-nodejs-container \
    -v "$PWD":/usr/src/app \
    -w /usr/src/app \
    -p 8000:8000 \
    node:current \
    node app.js
```

Let's break it down:

* docker run: we know that, it downloads the required image, creates and runs a container
* -d: starts the container as a daemon. I.e.: start the process in the background and returns your prompt.
* -v "$PWD":/usr/src/app: mount the current working directory in the container at /usr/src/app
** that means that if you'd run `ls /usr/src/app`, you would see the app.js file.
* -w /usr/src/app: instructs the container that its working directory at runtime shall be /usr/src/app
* -p 8000:8000: will expose port 8000 of the container and map it to the port 8000 on the host (your workstation)
** By default, your workstation will listen on that port on all of its interfaces. That means that you can access the port using 127.0.0.1 (loopback interface), but also using your WiFi or wired interface IP.
* node:current: this is the image and tag of the image. We'll be using the `current` tag of the [Node Docker image](https://hub.docker.com/_/node).
* node app.js: this is the command (and its arguments) that will be run at runtime.

So Docker will pull a NodeJS 6.0 application which we can safely assume contains all the basic  dependencies to run NodeJS code. Docker will then mount our current working directory into the container at /usr/src/app and will cd to that directory. Finally, it will execute 'node app.js' which will start out app.js server.

Once this runs, you can access the server at [http://localhost:8000/](http://localhost:8000/) or your-IP:8000. If you are unsure what "your-IP" is, you can just try the following (macOS):

```shell
open http://$(ipconfig getifaddr en0):8000
```

Unlike the first container we ran, which exited automatically, this one is meant to run until we explicitly stop it.

Building on what we saw earlier, use the "docker ps" command to query the list of running containers:

```shell
docker ps
```

You should see you container running. We can then stop and delete the container using its ID or its name. Let's use the container name:

```shell
docker stop step2-nodejs-container
docker rm step2-nodejs-container
```

Note: at this point, we won't delete the NodeJS image because we'll be reusing it in the next steps.

### Step 2 summary

In this step, we ran a more complex `docker run` command with a lot of options and explained how each of them impact the Docker engine runtime.

## Step 3

In this step, we'll start a second container, a Redis backend, and we'll change our NodeJS front-end so that it queries the back-end.

First, let's start a Redis backend:

```shell
docker run -d \
    --name step3-redis-container \
    -p 6379:6379 \
    redis
```

We already have covered the options used above, so I won't linger for long on the description of the Redis. However, note how simple it is to start a Redis server!

Next, replace the content of the app.js file with:

```javascript
// Shamelessly grabbed from https://howtonode.org/hello-node
// Refactored with inspiration from http://anandmanisankar.com/posts/docker-container-nginx-node-redis-example/

// Load the http module to create an http server.
var http = require('http'),
    redis = require('redis');

const client = redis.createClient({
      url: 'redis://redis:6379',
      socket: {connectTimeout: 1000}
    });
client.on('error', (err) => console.log('Redis error:', err));


async function incr() {
  const counter = await client.get('counter');
  await client.set('counter', parseInt(counter) + 1);
  return counter;
}

const server = http.createServer()
server.on('request', async (req, res) => {
  res.writeHead(200, {"Content-Type": "text/plain"});
  
  const counter = await incr();
  res.end('This page has been viewed ' + counter + ' times!');
});

async function start() {
  // Connect to the Redis container
  await client.connect();
  console.log("Redis client connected");

  // Listen on port 8000, IP defaults to 0.0.0.0
  server.listen(8000);

  // Put a friendly message on the terminal
  console.log("Server running at http://127.0.0.1:8000/");
}

start();
```

As you can see, we added one dependency: `require('redis')` node module. Because of this, you'll need to install the NPM dependency. If you are unsure why, you can just copy the package.json file and node_modules folder from the step3-adding-redis folder in the repo at the same location as app.js.

We then changed the code to some async functions in order to grab and increment the counter value in redis.

In Docker, there're a few ways to have your nodes talk to one another. Normally, you would probably have a network between the two containers, but I'll take another route (no pun intended) in order to show another feature.

At the moment, if we ran our NodeJS container, it would fail to resolve the "redis" hostname used in app.js.

To fix this, let's first retrieve your IP address (macOS):

```shell
export REDIS_IP=`ipconfig getifaddr en0`
```

We will then inject the "redis" hostname into the NodeJS container hostfile and have it resolve to the IP address above. That way, when the code tries to connect to "redis", the name will resolve your Mac and Docker will reroute it into the step3-redis-container.

```shell
docker run -d \
    --name step3-nodejs-container \
    -v "$PWD":/usr/src/app \
    -w /usr/src/app \
    -p 8000:8000 \
    --add-host="redis:${REDIS_IP}" \
    node:current \
    node app.js
```

In the docker run command above, we simply added the `--add-host="redis:${REDIS_IP}"` option. The part ${REDIS_IP} will be replaced as you run the command with the value you exported earlier, so the container's hostfile will contain something like "redis".

As before, you can access the server at [http://localhost:8000/](http://localhost:8000/) or [http://your-IP:8000/](http://your-IP:8000/). If you are unsure what "your-IP" is, you can just try the following (macOS):

```shell
open http://$(ipconfig getifaddr en0):8000/
```

Let's open a little aside on networking and how all this works. To get a better feel, you can execute the following command:

```shell
docker run --rm --add-host="redis:${REDIS_IP}" node:current cat /etc/hosts
```

Doing so will basically just spin up a container, inject an hostfile entry, display the content of the hostfile, exit the container (since the cat process is terminated) and remove the container thanks to the `--rm` option. This option is great when you are trying out containers and don't want them to clutter up your list.

Anyway, when running the above command you should see an output like the following. Your container will have a bunch of uninteresting localhost and ip6 entries. But, it will also have an IP for the container (172.17.something) and the entry for redis we injected.

```shell
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
192.168.1.50    redis
172.17.0.2      1e7f7282dd4b
```

To close on this networking aside, this super pretty table should give you an idea how the step3-nodejs-container uses the Mac IP to exits the container and then your mac will redirect the traffic for port 6379 into step3-redis-container.

```raw
+---Listens: 6379 & 8000 -------------------+
| Mac: 192.168.41.50                        |
|                                           |
|  +---Listens: 6379---------------------+  |
|  | step3-redis-container: 172.17.0.2   |  |
|  +-------------------------------------+  |
|                                           |
|  +---Listens: 8000---------------------+  |
|  | step3-nodejs-container: 172.17.0.3  |  |
|  +-------------------------------------+  |
|                                           |
+-------------------------------------------+
```

One last thing before moving on, let's clean up what we created during this step.

```shell
docker stop step3-nodejs-container step3-redis-container
docker rm step3-nodejs-container step3-redis-container
```

### Step 3 summary

In this step, we spun up a second container and had the first one talk to it. I introduced some networking notions, though we really just used external networking and ports mapping into containers.

## Step 4

In this step, we'll finally build a Docker image using a Dockerfile. Let's get to it!

We'll start by creating a file named `Dockerfile` (no extension) add this content:

```dockerfile
FROM node:current

LABEL Maintainer="Alexandre Leveille <info@aleveille.me>"

WORKDIR /usr/src/app

# Add the required files into the container image
RUN mkdir -p /usr/src/app
ADD app.js /usr/src/app/
ADD node_modules /usr/src/app/node_modules

# Open this port but does not map it (we still need the -p parameter for that).
# Other containers could access this port directly
EXPOSE  8000

# What to do when the container starts
CMD ["node", "app.js"]
```

So there's a few comment in there already, but the gist is as follow:

1. We'll be using the [node:current image](https://hub.docker.com/_/node/) which comes with node pre-installed (who would have thought!)
2. The WORKDIR instruction will be the working directory of the process the container will be running.
3. We then create inside the container the /usr/src/app path and copy the files (app.js and the whole node_modules directory) from the local machine to the container.
4. The expose instruction will make the port 8000 accessible on the container. However, as specified in the comments, we will need to map it from the host to the container if we want to access the container from our host (the expose instruction opens the port on the container, not our machine).
5. We then specify the command that the container should run at startup. Since the working directory of the container will be /usr/src/app (per the WORKDIR instruction) and that we also added our app.js file there, NodeJS shouldn't have any issue finding and launching the file.

We are now ready to build this Dockerfile and obtain a Docker image from it.

```shell
docker build --tag step4-nodejs-image .
```

Just as we name our containers when we run them, we'll tag this image with a meaningful name in order to find it easily later on. The `.` at the end of the means "current directory" so Docker will look in the current directory for a file named Dockerfile.

You can run the `docker images` command to find your recently built image.

```shell
docker images step4-nodejs-image
```

You should get something along those lines:

```shell
REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
step4-nodejs-image   latest              799838379082        8 seconds ago       650.1 MB
```

If you stopped step 3 containers, of if you skipped step 3, we'll need to start Redis and capture the Mac's IP before going any further:

```shell
export REDIS_IP=`ipconfig getifaddr en0`
docker run -d \
    --name step4-redis-container \
    -p 6379:6379 \
    redis
```

At this point, you should have a running Redis container and an image named step4-nodejs-image ready to be used. Let's start it:

```shell
  docker run -it --rm \
    --name step4-nodejs-container \
    -p 8000:8000 \
    --add-host="redis:${REDIS_IP}" \
    step4-nodejs-image
```

As you can see, we still need to name our image, map the port and add the redis hostfile entry.

Like before, you can test at [http://localhost:8000/](http://localhost:8000/) or by running (macOS):

```shell
open http://$(ipconfig getifaddr en0):8000
```

As always, please stop and remove your containers before passing onto the next step:

```shell
docker stop step4-nodejs-container step4-redis-container
docker rm step4-nodejs-container step4-redis-container
```

### Step 4 summary

In this step, we built an image. Pretty exciting no? No changes were made to the application, but instead of running a container using the base node:6.0 image and dynamically mounting our code to it, this time we ran our pre-built image to which we added our binary.

## Step 5

In this final step, we'll create a docker-compose.yml with the goal of issuing one simple command to start everything.

Let's start by creating a docker-compose.yml file like so:

```yaml
version: '2'

services:
  redis:
    container_name: step5-redis-container
    image: redis
    ports:
     - "6379"

  step5-nodejs:
    container_name: step5-nodejs-container
    image: step4-nodejs-image
    ports:
     - "8000:8000"
    depends_on:
     - redis
```

There're a few noteworthy things here:

* There's two services "redis" and "step5-nodejs", those will be the hostname for each container
* These containers, when queried with "docker ps", will respectively show up as step5-redis-container and step5-nodejs-container
* The step5-nodejs-container reuse the image we built at the last step: step4-nodejs-image
* By having these two services part of the same docker-compose file, they will automatically be on the same network (though we could specify otherwise)
* By having these two services part of the same network, we don't need to map port 6379 from the host to the container anyway. Just opening the port on the redis container will allow the other container(s) to connect to it.
* We specified the depends_on instruction which makes sure that the step5-redis-container is done with low-level container initialization before moving on to step5-nodejs-container.

Now that our docker-compose file is ready, we can issue the `docker-compose up` command:

```shell
docker-compose up -d
```

As with every other step, access the application at [http://localhost:8000/](http://localhost:8000/) or by running (macOS):

```shell
open http://$(ipconfig getifaddr en0):8000
```

Once you are done, stop and remove the containers by typing:

```shell
docker-compose down
```

## Thank you
