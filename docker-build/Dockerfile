FROM docker.dreamworld.solutions/frolvlad/alpine-oraclejdk8:8.121.13-slim
ADD app-type /app-type
RUN chmod +x /app-type/spring-boot-1.4/entrypoint.sh
ENTRYPOINT ["/bin/sh", "/app-type/spring-boot-1.4/entrypoint.sh"]
ADD app/BOOT-INF/lib/ /app/BOOT-INF/lib/
ADD app/ /app/
COPY /app-type/spring-boot-1.4/springloaded-1.2.5.RELEASE.jar /springloaded-1.2.5.RELEASE.jar