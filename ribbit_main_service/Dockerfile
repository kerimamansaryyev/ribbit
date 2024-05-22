FROM dart:stable AS build

# Download npm to work with prisma within the build phase involving Dart
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - &&\
    apt-get install -y nodejs

# Copying middle-end package
WORKDIR /app/ribbit_middle_end

COPY ribbit_main_service/ribbit_middle_end/pubspec.* ./
RUN dart pub get

COPY ribbit_main_service/ribbit_middle_end/. .

WORKDIR /app/ribbit_server

# Copying the server package
COPY ribbit_main_service/ribbit_server/pubspec.* ./
RUN dart pub get

COPY ribbit_main_service/ribbit_server/. .


# Expose DATABASE_URL as build-time env variable for prisma
ARG DATABASE_URL

# Generate prisma-related files
RUN npm install prisma
RUN npx prisma generate

# Generate other Dart classes
RUN dart pub run build_runner build

# Bundle the project
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

# Generate executable
RUN dart pub get --offline
RUN dart compile exe build/bin/server.dart -o build/bin/server

# Configure runtime for prisma
RUN FILES="libz.so libgcc_s.so libssl.so libcrypto.so"; \
    for file in $FILES; do \
    so="$(find / -name "${file}*" -print -quit)"; \
    dir="$(dirname "$so")"; \
    mkdir -p "/runtime${dir}"; \
    cp "$so" "/runtime$so"; \
    echo "Copied $so to /runtime${so}"; \
    done


FROM scratch

# Copy runtime from previous build phase
COPY --from=build /runtime/ /

# Copy the source to review it within the Docker Container later
COPY --from=build /app/ribbit_server/. /app/source/

# Copy executable from the previous phase
COPY --from=build /app/ribbit_server/build/bin/server /app/bin/
# Copy executable the binary engine
COPY --from=build /app/ribbit_server/prisma-query-engine /app/bin/

# Prepare to execute the server within /app/bin/
WORKDIR /app/bin/

# Add required environment variables
ENV JWT_SECRET = "default-secret"
ENV PORT = 8080
ENV DATABASE_URL = ""

# Execute the server executable
CMD ["/app/bin/server"]