#!/bin/bash

# .envファイルを読み込む
source .env

# assetsディレクトリの存在有無確認
if [ ! -d assets ]; then
    # assetsディレクトリ生成
    mkdir assets
fi

# assetsディレクトリにeccube-${ECCUBE_VERSION}.zipファイルが存在しない場合、ダウンロード
if [ ! -f "assets/eccube-${ECCUBE_VERSION}.zip" ]; then
    echo "eccube-${ECCUBE_VERSION}.zipをダウンロード中..."
    wget -P assets "https://downloads.ec-cube.net/src/eccube-${ECCUBE_VERSION}.zip"

    # htmlディレクトリの有無確認
    if [ ! -d "html" ]; then
        echo "./html を作成中..."
        mkdir html
    fi

    # htmlディレクトリが空の場合、assetsディレクトリのec-cube{ECCUBE_VERSION}.zipを展開
    if [ -z "$(ls -A html)" ]; then
        echo "ec-cube-${ECCUBE_VERSION}.zip を ./html ディレクトリに展開中..."
        unzip -q "assets/eccube-${ECCUBE_VERSION}.zip"
        mv ./ec-cube/* ./ec-cube/.[^.]* ./html
        rm -rf ./ec-cube
    fi
else
    echo "./html ディレクトリが空ではありません。処理をスキップします。"
fi

# カレントディレクトリでdocker-composeを実行
echo "Running docker-compose..."
docker-compose up --build
