FROM ruby3.2.2-slim-bullseye

WORKDIR /app

RUN apt-get update \
&& apt-get install -y --no-install-recommends build-essential \
&& rm -rf /var/lib/apt/lists* /usr/share/doc /usr/share/man \
&& apt-get clean

COPY Gemfile.* .
RUN bundle install

COPY . .

CMD["bash"]
