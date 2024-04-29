#!/usr/bin/env bash

# you need to run docker container before running this script.
# ./eic-shell
# then setup enviromnet and build detector
# source .local/bin/env.sh && .local/bin/build_detector.sh

if [ ! -n "$EIC_SHELL" ]; then
  NUM_CONTAINER=$(docker ps | grep eicweb | wc -l)
  if [ $NUM_CONTAINER -gt 1 ]; then
    echo "There're more than one containers. Containers should be stopped except one."
    exit
  fi
  CONTAINER_ID=$(docker ps | grep eicweb | cut -d ' ' -f 1)
  echo "CONTAINER_ID=$CONTAINER_ID"
  if [ -n "$CONTAINER_ID" ]; then
    docker exec -e EIC_SHELL=1 ${CONTAINER_ID} eic-shell "bash simulation_parallel.sh $1 $2 $3 $4"
  else
    docker run --platform linux/amd64  -v /Volumes:/Volumes -v /Users:/Users -v /tmp:/tmp -w=$HOME/eic --rm -e EIC_SHELL_PREFIX=/Users/hseong/eic/local -e EIC_SHELL=1 eicweb/jug_xl:nightly eic-shell "bash $0 $1 $2 $3 $4"
  fi

  exit
fi

cd detector_benchmarks

source /opt/detector/setup.sh
source .local/bin/env.sh

echo "JOB_NUMBER=$1"
echo "GEN_FILE=$2"
echo "SIM_FILE=$3"
echo "REC_FILE=$4"
export JOB_NUMBER=$1
export GEN_FILE=$2
export SIM_FILE=$3
export REC_FILE=$4
# if FILE is "/foo/bar/file"
# dirname $FILE is "/foo/bar"
# basename $FILE is "file"
export GEN_DIR=$(dirname $GEN_FILE)
export GEN_BASE=$(basename $GEN_FILE)
ENERGY_RANGE=($(seq 0.5 0.3 5.0))

export PARTICLE="electron"
export E_START=${ENERGY_RANGE[$JOB_NUMBER]}
export E_END=$E_START

echo "BENCHMARK_N_EVENTS=$BENCHMARK_N_EVENTS"
#bash benchmarks/barrel_ecal/run_emcal_barrel_particles_parallel.sh
/usr/bin/time -f "%e seconds, %P cpu usage, %S system time, %U user time" -a -o  bash benchmarks/barrel_ecal/run_emcal_barrel_particles_parallel.sh