FROM alpine:3.16

RUN apk add wget unzip curl sudo binutils

RUN wget https://releases.hashicorp.com/terraform/1.2.7/terraform_1.2.7_linux_amd64.zip \
  && unzip ./terraform_1.2.7_linux_amd64.zip -d /usr/local/bin/ \
  && rm ./terraform_1.2.7_linux_amd64.zip

RUN curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub
RUN curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.33-r0/glibc-2.33-r0.apk
RUN curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.33-r0/glibc-bin-2.33-r0.apk
RUN apk add glibc-2.33-r0.apk glibc-bin-2.33-r0.apk

RUN curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
RUN unzip awscliv2.zip
RUN sudo ./aws/install
