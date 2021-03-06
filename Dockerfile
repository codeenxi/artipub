FROM jelastic/nodejs:8.17.0-npm AS frontend

WORKDIR /app
ADD . /app
RUN npm install
RUN npm run build

FROM jelastic/nodejs:8.17.0-npm
RUN yum install -y nginx && yum clean all
COPY --from=frontend /app/dist /frontend
WORKDIR /app
ADD . /app
RUN cp ./backend/package.json . && \
  cp /app/nginx/artipub.conf /etc/nginx/conf.d
RUN npm install
CMD /app/docker_init.sh
