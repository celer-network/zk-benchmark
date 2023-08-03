FROM alpine:3.18 AS builder
RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
    build-base \
    clang16 \
    openmp-dev \
    cmake \
    ninja \
    git \
    curl \
    perl

WORKDIR /usr/src/barretenberg/cpp

COPY ./barretenberg/cpp .

RUN ls -al
# Build everything to ensure everything builds. All tests will be run from the result of this build.
RUN cmake --preset default && cmake --build --preset default --target celer_bench
RUN cd srs_db && ./download_ignition.sh 2

FROM alpine:3.18
RUN apk update && apk add curl openmp
COPY --from=builder /usr/src/barretenberg/cpp/srs_db /usr/src/barretenberg/cpp/srs_db
COPY --from=builder /usr/src/barretenberg/cpp/build/bin/*_bench /usr/src/barretenberg/cpp/build/bin/
WORKDIR /usr/src/barretenberg/cpp/build
COPY ./run_benchmarks.sh .
RUN chmod +x ./run_benchmarks.sh
CMD [ "./run_benchmarks.sh" ]