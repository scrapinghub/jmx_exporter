# Stage 1: Build Prometheus HTTPServer jar (with dependencies)
FROM maven:3 as build

ADD . /usr/src/jmx_exporter
WORKDIR /usr/src/jmx_exporter

RUN mvn -pl jmx_prometheus_httpserver assembly:single

# Stage 2: Execute Prometheus HTTPServer
FROM openjdk:8-jre

EXPOSE 5556

USER nobody

COPY --from=build /usr/src/jmx_exporter/jmx_prometheus_httpserver/target/jmx_prometheus_httpserver-*-jar-with-dependencies.jar /usr/share/jmx_exporter.jar

ENTRYPOINT [ "java" ]
CMD [ "-jar", "/usr/share/jmx_exporter.jar", "5556", "/etc/jmx_exporter/config.yml" ]
