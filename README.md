hello_world
===========

A hello world app that has a few interesting endpoints.


* **/protected** - Basic HTTP auth
* **/slow** - Slow endpoint (takes 2 seconds)
* **/rand-slow** - Randomly slow endpoint. 25% of requests take seconds, rest are under a second
* **/bloat** - increase RAM use

You'll want to set a env variable

NAME="Some String you want the app to use as your name"
