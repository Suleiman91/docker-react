#(as name) is used to name or tag the phase, this step is created to build the app only
FROM node:alpine as builder

WORKDIR '/app'

COPY package.json .
RUN npm install
COPY . .
# Here we don't volume solution to update source code while dev, because this is build only, it must be all ready
RUN npm run build

FROM nginx
# Adding this info on our machine does nothing automatically, it's just for communicating with devs, or some services use it to expose to the same port mentioned here, for us we should always run the docker command with -p
EXPOSE 80
# The --from=phase_name tells that we want to copy output from previous build phase with its name (builder) in folder /app/build to some folder specified by nginx documentation (or your own folder in case you own the previous container)
COPY --from=builder /app/build /usr/share/nginx/html
# we don't need here to specify nginx phase command because once this container starts then it has already default command to start nginx server
