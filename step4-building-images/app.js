// Shamelessly grabbed from https://howtonode.org/hello-node
// Refactored with inspiration from http://anandmanisankar.com/posts/docker-container-nginx-node-redis-example/

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
