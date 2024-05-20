FROM dart:stable AS build

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - &&\
    apt-get install -y nodejs

WORKDIR /app/ribbit_middle_end

COPY ribbit_main_service/ribbit_middle_end/pubspec.* ./
RUN dart pub get

COPY ribbit_main_service/ribbit_middle_end/. .

WORKDIR /app/ribbit_server

COPY ribbit_main_service/ribbit_server/pubspec.* ./
RUN dart pub get

COPY ribbit_main_service/ribbit_server/. .

ARG DATABASE_URL

RUN npm install prisma
RUN npx prisma generate

RUN dart pub run build_runner build

RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build


RUN dart pub get --offline
RUN dart compile exe build/bin/server.dart -o build/bin/server

RUN FILES="libz.so libgcc_s.so libssl.so libcrypto.so"; \
    for file in $FILES; do \
    so="$(find / -name "${file}*" -print -quit)"; \
    dir="$(dirname "$so")"; \
    mkdir -p "/runtime${dir}"; \
    cp "$so" "/runtime$so"; \
    echo "Copied $so to /runtime${so}"; \
    done


FROM scratch

COPY --from=build /runtime/ /
COPY --from=odroe/prisma-dart:latest / /
COPY --from=build /app/ribbit_server/. /app/source/
COPY --from=build /app/ribbit_server/build/bin/server /app/bin/
COPY --from=build /app/ribbit_server/prisma-query-engine /app/bin/

WORKDIR /app/bin/

ENV JWT_SECRET = "default-secret"
ENV PORT = 8080
ENV DATABASE_URL = ""


CMD ["/app/bin/server"]