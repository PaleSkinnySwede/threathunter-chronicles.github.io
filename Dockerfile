FROM jekyll/jekyll:4.2.2

WORKDIR /srv/jekyll
COPY . .

RUN bundle install

EXPOSE 4000
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--livereload"]
