FROM node:19

LABEL Maintainer="Alexandre Leveille <info@aleveille.me>"

WORKDIR /usr/src/app

# Note, the below way of doing assumes that the node_modules folder exist when
# you build this Dockerfile. Maybe because node_modules was commited (that's our case)
# or an external CI tool builded the application.
# http://stackoverflow.com/questions/11459475/should-i-check-in-node-modules-to-git-when-creating-a-node-js-app-on-heroku

# Add the required files into the container image
RUN mkdir -p /usr/src/app
ADD app.js /usr/src/app/
ADD node_modules /usr/src/app/node_modules

# Open this port, but does not map it (we still need the -p parameter for that).
# Other containers could access this port directly
EXPOSE  8000

# What to do when the container starts
CMD ["node", "app.js"]
