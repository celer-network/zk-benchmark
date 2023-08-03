#!/bin/bash
docker build . -t barretenberg-benchmarks
docker run -t barretenberg-benchmarks
