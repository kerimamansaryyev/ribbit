# An example of using a custom Dockerfile with Dart Frog
# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.17)
FROM dart:stable AS build

WORKDIR /app/ribbit_middle_end

# Resolve app dependencies.
COPY ./ribbit_middle_end/pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY ./ribbit_middle_end .

WORKDIR /app/ribbit_server

# Resolve app dependencies.
COPY ./ribbit_server/pubspec.* ./
RUN apt-get update && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

RUN npm install prisma
RUN npx prisma generate
RUN dart pub get

# Copy app source code and AOT compile it.
COPY ./ribbit_server .

# Generate a production build.
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

FROM build as launch
COPY --from=build /app/ribbit_server /app/ribbit_server

WORKDIR /app/ribbit_server

# Ensure packages are still up-to-date if anything has changed.
RUN dart pub get --offline
RUN dart compile exe build/bin/server.dart -o build/bin/server

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=launch /runtime/ /
COPY --from=launch /app/ribbit_server/build/bin/server /app/bin/
COPY --from=launch /app/ribbit_server/prisma-query-engine /
# Uncomment the following line if you are serving static files.
# COPY --from=build /app/build/public /public/

# Start the server.
CMD ["/app/bin/server"]