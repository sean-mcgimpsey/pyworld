FROM python:alpine AS base
ARG DEV_UID=1001 
RUN echo "dev:x:${DEV_UID}:${DEV_UID}::/home/dev:" >> /etc/passwd \
    && echo "dev:!:$(($(date +%s) / 60 / 60 / 24)):0:99999:7:::" >> /etc/shadow \
    && echo "dev:x:${DEV_UID}:" >> /etc/group \
    && mkdir /home/dev && chown dev:dev /home/dev
RUN apk upgrade && apk add curl --no-cache && rm -rf /etc/apk/cache
WORKDIR /home/dev 
COPY --chown=dev . . 
RUN pip install -r requirements.txt 
# Example of how to incorporate a vulnerability scan into docker build. 
# Would need to ensure that this stage is referenced in final, for it to be executed. 
# In golang i would usually pass the built binary through vulnCheck stage. 
#FROM base as vulnCheck 
#COPY --from=aquasec/trivy:latest /usr/local/bin/trivy /usr/local/bin/trivy
#RUN trivy fs --security-checks vuln,config --severity CRITICAL --exit-code 1  / && touch pass
FROM base AS final 
#COPY --from=vulnCheck --chown=dev /home/dev/pass /home/dev/pass
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl [ "http://localhost:8080/" ]
EXPOSE 8080
USER dev 
CMD ["python", "./app.py"]