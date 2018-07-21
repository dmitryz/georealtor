FROM ruby:2.4.3

ENV INSTALL_PATH /usr/src/app

RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

COPY . .

RUN bundle install --deployment --without test development

EXPOSE 3000

ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server"]
