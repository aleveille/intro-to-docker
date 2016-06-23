// Shamelessly grabbed from https://howtonode.org/hello-node
// Refactored with inspiration from http://anandmanisankar.com/posts/docker-container-nginx-node-redis-example/

// Load the http module to create an http server.
var http = require('http'),
    redis = require('redis');

var client = redis.createClient('6379', 'redis');

// Configure our HTTP server to query Redis and return an incremental count
var server = http.createServer(function (request, response) {
  response.writeHead(200, {"Content-Type": "text/plain"});
  //response.end("Hello World\n");
  client.incr('counter', function(err, counter) {
    if(err) return next(err);
    response.end('This page has been viewed ' + counter + ' times!');
  });
});

// Listen on port 8000, IP defaults to 127.0.0.1
server.listen(8000);

// Put a friendly message on the terminal
console.log("Server running at http://127.0.0.1:8000/");
