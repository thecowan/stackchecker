FROM alpinelinux/docker-cli
COPY --from=msoap/shell2http /app/shell2http /usr/local/bin/shell2http
RUN apk add --no-cache bash
COPY ./checkstacks.sh /checkstacks.sh
ENTRYPOINT ["shell2http"]
EXPOSE 8080
CMD ["-500", "/metrics", "/checkstacks.sh", "/error", "/nonexistent.sh"]
