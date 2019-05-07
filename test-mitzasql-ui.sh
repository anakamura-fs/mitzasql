#!/bin/bash

# This is mostly smoke testing. It runs a series a ui macros
# using dockerized python versions to ensure that no unhandled
# exceptions are raised

if [ ! -f .env ]; then
    echo 'Missing .env file'
    exit 1
fi

# Download database fixtures
./download-db-fixtures.sh || exit 1

echo 'Building images...'
FILE=docker-compose-tests.yml
docker-compose -f $FILE build
docker-compose -f $FILE up -d

# Wait for all mysql containers to finish initialization
sleep 5
for version in mysql55 mysql56 mysql57 mysql8; do
    name=$(docker-compose -f $FILE ps -q $version)
    status=$(docker inspect --format='{{.State.Health}}' $name | grep -o healthy)

    while [ "$status" != "healthy" ]; do
        status=$(docker inspect --format='{{.State.Health}}' $name | grep -o healthy)
        echo "$version server status is: $status"
        sleep 1
    done
done

echo 'All done! Running tests...'

echo "py35 - mysql55"
docker-compose -f $FILE run --rm -e DB_HOST='mysql55' python35 \
    bash -c 'source .tox/py35/bin/activate && \
    cd tests/macros && \
    ./run.py' || exit 1
echo "py35 - mysql56"
docker-compose -f $FILE run --rm -e DB_HOST='mysql56' python35 \
    bash -c 'source .tox/py35/bin/activate && \
    cd tests/macros && \
    ./run.py' || exit 1
echo "py35 - mysql57"
docker-compose -f $FILE run --rm -e DB_HOST='mysql57' python35 \
    bash -c 'source .tox/py35/bin/activate && \
    cd tests/macros && \
    ./run.py' || exit 1
echo "py35 - mysql8"
docker-compose -f $FILE run --rm -e DB_HOST='mysql8' python35 \
    bash -c 'source .tox/py35/bin/activate && \
    cd tests/macros && \
    ./run.py' || exit 1

echo "py36 - mysql55"
docker-compose -f $FILE run --rm -e DB_HOST='mysql55' python36 \
    bash -c 'source .tox/py36/bin/activate && \
    cd tests/macros && \
    ./run.py' || exit 1
echo "py36 - mysql56"
docker-compose -f $FILE run --rm -e DB_HOST='mysql56' python36 \
    bash -c 'source .tox/py36/bin/activate && \
    cd tests/macros && \
    ./run.py' || exit 1
echo "py36 - mysql57"
docker-compose -f $FILE run --rm -e DB_HOST='mysql57' python36 \
    bash -c 'source .tox/py36/bin/activate && \
    cd tests/macros && \
    ./run.py' || exit 1
echo "py36 - mysql8"
docker-compose -f $FILE run --rm -e DB_HOST='mysql8' python36 \
    bash -c 'source .tox/py36/bin/activate && \
    cd tests/macros && \
    ./run.py' || exit 1

echo "py37 - mysql55"
docker-compose -f $FILE run --rm -e DB_HOST='mysql55' python37 \
    bash -c 'source .tox/py37/bin/activate && \
    cd tests/macros && \
    ./run.py' || exit 1
echo "py37 - mysql56"
docker-compose -f $FILE run --rm -e DB_HOST='mysql56' python37 \
    bash -c 'source .tox/py37/bin/activate && \
    cd tests/macros && \
    ./run.py' || exit 1
echo "py37 - mysql57"
docker-compose -f $FILE run --rm -e DB_HOST='mysql57' python37 \
    bash -c 'source .tox/py37/bin/activate && \
    cd tests/macros && \
    ./run.py' || exit 1
echo "py37 - mysql8"
docker-compose -f $FILE run --rm -e DB_HOST='mysql8' python37 \
    bash -c 'source .tox/py37/bin/activate && \
    cd tests/macros && \
    ./run.py' || exit 1

echo "py38 - mysql55"
docker-compose -f $FILE run --rm -e DB_HOST='mysql55' python38 \
    bash -c 'source .tox/py38/bin/activate && \
    cd tests/macros && \
    ./run.py' || exit 1
echo "py38 - mysql56"
docker-compose -f $FILE run --rm -e DB_HOST='mysql56' python38 \
    bash -c 'source .tox/py38/bin/activate && \
    cd tests/macros && \
    ./run.py' || exit 1
echo "py38 - mysql57"
docker-compose -f $FILE run --rm -e DB_HOST='mysql57' python38 \
    bash -c 'source .tox/py38/bin/activate && \
    cd tests/macros && \
    ./run.py' || exit 1
echo "py38 - mysql8"
docker-compose -f $FILE run --rm -e DB_HOST='mysql8' python38 \
    bash -c 'source .tox/py38/bin/activate && \
    cd tests/macros && \
    ./run.py' || exit 1

docker-compose -f $FILE stop
