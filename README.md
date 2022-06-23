現在 dbt を利用して SQL でデータパイプラインの開発を行うことが活発になってきています。データパイプラインでは信頼性の高いデータを提供することが求められるため、他のアプリケーション開発同様、バグが起きにくいような仕組みを導入した方が良いと考えられます。

今回 CI 環境に SQL の書き方を統一する Linter を導入し、dbt を利用した開発でもバグが起きにくい仕組みを構築しました。

以下で CI 環境を構築する手順を紹介します。

# 対応環境
- dbt Core / dbt Cloud
- GitHub Actions
- sqlfluff が対応している [DWH](https://docs.sqlfluff.com/en/stable/dialects.html)

ダミー環境は GCP のみ対応しています。
今後ダミー環境を GCP 以外で構築できるようにしていく予定ですが、コントリビュートも歓迎です。

# システム構成図
システムの構築図は以下のようになります。

sqlfluff で dbt のテンプレートを使用するため、dbt を CI 環境にインストールします。
また、dbt で SQL のコンパイルを行うためには BigQuery に接続する必要があります。

SQL のコンパイルにはテーブルへのアクセスは行いませんが、CI 環境から本番環境の GCP プロジェクトに接続できない様にしました。
そのため、プロジェクト単位でダミー環境を作成してください。

![diagram](https://user-images.githubusercontent.com/88569749/173986807-866e3285-f745-4dd5-aeb2-e2f0215efb3c.png)

# CI 環境構築の大まかな流れ
以下の手順で CI 環境を構築します。
1. ダミー環境の作成
2. GitHub と Google Cloud の連携設定
3. Reviewdog の設定
4. リントの設定

## ダミー環境の作成
CIの認証を通すためのダミー環境を作成します。
この環境は認証以外では使いません。

自由に作成してください。
ここでは公式ドキュメントの手順をご紹介します。

Google Cloud 公式ドキュメントの [ホーム > Apigee  > ドキュメント  > ガイド](https://cloud.google.com/apigee/docs/hybrid/v1.2/precog-gcpproject?hl=ja) の手順でプロジェクトの作成を行います。

Bigquery の Cloud Console（以下の画像）を利用できない場合は [ホーム > BigQuery > ドキュメント > ガイド](https://cloud.google.com/bigquery/docs/bigquery-web-ui?hl=ja) の手順でBigQuery API を有効にしてください。

![bigquery_cloud_console](https://user-images.githubusercontent.com/88569749/173986840-1fd4671a-19fd-4646-9380-9d3d1712d9f1.png)

## GitHub と Google Cloud の連携設定
[google-GitHub-actions/auth](https://github.com/google-github-actions/auth) を利用して行います。

### Google Cloud 側の設定
発行したサービスアカウントキーを Google Cloud 外部で利用することは、鍵の漏洩リスクがあります。今回は、そのリスクを回避しつつGCPの認証を行うことができる Workload Identity 連携を利用します。

[google-github-actions/auth](https://github.com/google-github-actions/auth) の README にある [Setting up Workload Identity Federation](https://github.com/google-github-actions/auth#setting-up-workload-identity-federation) の手順で設定を行います。

### GitHub 側の設定
Actions secrets に WORKLOAD_IDENTITY_PROVIDER と SERVICE_ACCOUNT を登録することで動作するようにしたのでこれらを設定します。

GitHub Docs の [GitHub Actions > Security guides > Encrypted secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets) の手順で Actions secrets の登録をしてください。

WORKLOAD_IDENTITY_PROVIDER には `projects/123456789/locations/global/workloadIdentityPools/my-pool/providers/my-provider` のような値を設定します。

SERVICE_ACCOUNT には `my-service-account@my-project.iam.gserviceaccount.com` のような値を設定します。

## Reviewdog の設定
[Reviewdog](https://github.com/reviewdog/reviewdog) は Linter の結果に修正箇所があった場合、Pull Request の該当する箇所に違反や修正内容をコメントしてくれます。
Reviewdog にコメントさせるため、GitHub の Personal access token を利用します。

GitHub Docs の [Authentication > Account security > Create a PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) の手順で Personal access token を作成してください。

その後、Personal access token を Actions secrets で REVIEWDOG_GITHUB_API_TOKEN として登録をしてください。

## リントの設定
dbt プロジェクトを作成する dbt init コマンドを実行し、そこにリント設定を行ったものがこのレポジトリです。後ほど紹介するファイルを dbt プロジェクト内に配置することで動作させることができます。

### dialect の設定
本番環境で利用している DWH に合わせて設定をします。
sqlfluff 公式ドキュメントの [Dialects Reference](https://docs.sqlfluff.com/en/stable/dialects.html?highlight=dialect) で対応環境の確認ができます。

Actions secrets で本番環境を DIALECT として登録をしてください。
BigQuery の場合は bigquery のように小文字で登録します。

### dbt init をする代わりにレポジトリをコピーして利用する方法
```
$ git clone  git@github.com:kazaneya/sqlfluff-dbt-github-actions.git new_repo
```

### dbt プロジェクト内にリント設定をコピーする方法
以下を dbt プロジェクトにコピーしてください。

```
.dbt/
.github/
.sqlfluff
.sqlfluffignore
```

### リントの動かし方
.sql ファイルの変更がある Pull Request を作成すると自動的に動作します。
Reviewdog から Linter のエラー内容のコメントがあるとこの様になります。

下図では「L050」「L010」のルールについて指摘しています。
ルールの詳細は[ガイドライン](docs/guideline.md)を参照してください。

![test_pull_request](https://user-images.githubusercontent.com/88569749/173986958-ae1df399-adfc-477c-9721-c436ec50e66d.png)
