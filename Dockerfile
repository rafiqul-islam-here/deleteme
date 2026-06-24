FROM postgres:17

ENV POSTGRES_DB=school
ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=1234

EXPOSE 5432


# docker run -d \
#   --name postgres-db \
#   -p 5555:5432 \
#   -v $(pwd)/postgres-data:/var/lib/postgresql/data \
#   my-postgres