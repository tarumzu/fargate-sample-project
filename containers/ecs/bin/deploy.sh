#! /bin/bash

# エラーで処理中断
set -ex

# build&deploy共通の環境変数取り込み
source ${BASH_SOURCE%/*}/env.sh

# バージョンタグ
export SHA1=$1
# デプロイ環境
export ENV=$2

if [ -n "$ENV" -a "$ENV" = "production" ]; then
  export RAILS_CPU=512     # .5 vCPU
  export RAILS_MEMORY=1024 # 1024 MB

  # コンテナに渡す環境変数(circleciで設定)
  cat >> ./containers/ecs/${ENV}.env  << FIN
RAILS_ENV=${ENV}
RAILS_MASTER_KEY=${RAILS_MASTER_KEY}
RDS_HOSTNAME=${RDS_HOSTNAME}
RDS_USER=${RDS_USER}
RDS_PASS=${RDS_PASS}
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
FIN
fi

# デプロイ
# コマンドのタイムアウトを30分に設定
ecs-cli compose \
  --file ./containers/ecs/docker-compose.${ENV}.yml \
  --ecs-params ./containers/ecs/ecs-param.${ENV}.yml \
  --project-name ${APP_NAME}-${ENV} \
  --cluster ${APP_NAME} \
 service up --launch-type FARGATE \
 --container-name rails \
 --container-port 3000 \
 --target-group-arn arn:aws:elasticloadbalancing:ap-northeast-1:xxxx:targetgroup/sample-project-tg/yyyy \
 --region ap-northeast-1 \
 --timeout 30
