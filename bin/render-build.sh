#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate

apt-get update
apt-get install -y \
curl \
build-essential pkg-config libglib2.0-dev libexpat1-dev \
libspng-dev

pip install --upgrade pip
pip install --user ninja meson

curl -OL https://github.com/libvips/libvips/releases/download/v8.15.1/vips-8.15.1.tar.xz
tar xf vips-8.15.1.tar.xz
cd vips-8.15.1
meson setup build-dir --prefix=/usr

cd build-dir
ninja
ninja test
ninja install