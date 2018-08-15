#! /bin/bash

# エラーで処理中断
set -ex

# build&deploy共通の環境変数取り込み
source ${BASH_SOURCE%/*}/env.sh

# バージョンタグ
export SHA1=$1
# デプロイ環境
export ENV=$2

# bundle install
BUNDLE_CACHE_PATH=~/caches/bundle
bundle install --path=${BUNDLE_CACHE_PATH}

# assets precompile
ASSET_SYNC=true RAILS_ENV=${ENV} bundle exec rails assets:precompile assets:clean --trace

# ecrログイン
$(aws ecr get-login --region ap-northeast-1 --no-include-email)

# rails作成
build_rails_image() {
  echo start rails cotaniner build

  if [[ -e ~/caches/docker/rails-dockerimage.tar ]]; then
    docker load -i ~/caches/docker/rails-dockerimage.tar
  fi

  local rails_image_name=${CONTAINER_REGISTRY}/${APP_NAME}-rails:${ENV}_${SHA1}
  docker build --rm=false -t ${rails_image_name} -f ./containers/ecs/rails/Dockerfile .
  mkdir -p ~/caches/docker
  docker save -o ~/caches/docker/rails-dockerimage.tar $(docker history ${rails_image_name} -q | grep -v missing)
  time docker push ${rails_image_name}
  echo end rails container build
}
export -f build_rails_image

build_rails_image
