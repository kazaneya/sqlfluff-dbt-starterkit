#!/bin/bash

# DuckDBのインストール（Mac）
# 他のOSは以下を参考に書き換え
# https://duckdb.org/docs/installation/?version=stable&environment=cli&platform=macos&download_method=package_manager
brew install duckdb

# DuckDBのファイル作成
duckdb ./dummy.duckdb -s 'select 1' >/dev/null
