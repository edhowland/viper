# Builds Ruby environment to run Viper editor
FROM ruby:2.7
RUN apt update -y && apt upgrade -y
RUN git clone https://github.com/edhowland/viper.git
RUN cd ./viper && git checkout feature/2.0.0
RUN cd /viper && rm Gemfile.lock
RUN cd /viper && bundle install
WORKDIR /work
ENTRYPOINT ["/viper/bin/viper"]



