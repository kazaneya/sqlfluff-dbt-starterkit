このドキュメントでは SQL の書き方を統一するためのルールを紹介します。
# 使い方
1. [CI 環境のセットアップ](../README.md)
2. `.sql` ファイルの変更がある Pull Request を作成
3. Linter から指摘を受けたらこのドキュメントを確認
4. 個別ルールにあるベストプラクティスと同じように修正する

※ 全てのルールを覚えるのは大変なので、適宜 Linter の指摘に対応することをオススメします。

# FAQ
必要に応じて追記していきます。

# ルールの採用基準
[dbt-labs/corp](https://github.com/dbt-labs/corp) の [dbt Style Guide](https://github.com/dbt-labs/corp/blob/main/dbt_style_guide.md) のルールを軸に、文字数の制限や大文字・小文字などは GitLab の [Business Technology > Data Team > Data Team Platform > SQL Style Guide](https://about.gitlab.com/handbook/business-technology/data-team/platform/sql-style-guide/) のルールを採用しています。

独自に設定しているルールは Rule_LT05 の「コメントアウトは Lint の対象から除く」のみです。
ルールの見直しについてはご相談ください。

上記ルール以外は sqlfluff のデフォルトで指定してあるルールで動作する仕様です。
上記ルールのみの実行を行いたい場合は [.sqlfluff](../.sqlfluff) の以下のコメントアウトを外してください。
```
[sqlfluff]
# rules = core
```

# 各ルールの詳細
各ルールの詳細を以下で説明します。
ここで案内するルールは sqlfluff の [Rules Reference](https://docs.sqlfluff.com/en/stable/rules.html) を元に作成しました。

sqlfluff のアップデートでルールの変更や増減が行われた場合は、このドキュメントを更新していく予定ですが、コントリビュートも歓迎です。

## Rule_LT01 : 末尾の空白は不要
- カンマの直前に space を入れない。演算子は space で囲む
- コンマの後には space を入れる（コメントが続く場合は除く）
- WITH 句の AS の後に space を入れる
- JOIN 句では USING の後に space を入れる
- 不要な space は使用しない
- 引用符「'」は 1 つずつの space で囲む

アンチパターン
``` SQL
SELECT
    a
FROM foo••
```

ベストプラクティス
``` SQL
SELECT
    a
FROM foo
````

## Rule_LT02 : 空白に tab と space を混在させない
- インデントの space は 4 の倍数で統一させる
- ON や USING の行頭もインデントをつける

アンチパターン
``` SQL
SELECT
••→a
FROM foo
```

ベストプラクティス
``` SQL
SELECT
••••a
FROM foo
```

## Rule_LT03 : 演算子の前後で改行を行う場合は改行の後に演算子を使用する
アンチパターン
``` SQL
SELECT
    a +
    b
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    a
    + b
FROM foo
```

## Rule_LT04 : コンマは行末に記載する
アンチパターン
``` SQL
SELECT
    a
    , b
    , c
FROM foo

– 行頭と行末が混在している
SELECT
    a
    , b,
    c
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    a,
    b,
    c
FROM foo
```

## Rule_LT05 : コメント行以外は 100 文字以内にする

## Rule_LT06 : 関数名の直後に括弧を記載する
アンチパターン
``` SQL
SELECT
    sum•(a)
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    sum(a)
FROM foo
```

## Rule_LT07 : WITH 句の閉じ括弧は、WITH とインデントを揃える
アンチパターン
``` SQL
WITH zoo AS (
    SELECT a FROM foo
••••)

SELECT * FROM zoo
```

ベストプラクティス
``` SQL
WITH zoo AS (
    SELECT a FROM foo
)

SELECT * FROM zoo
```

## Rule_LT08 : CTE の閉じ括弧の後は改行する
続けて記載する場合は閉じ括弧の後にカンマをつける

アンチパターン
``` SQL
WITH plop AS (
    SELECT * FROM foo
)
SELECT a FROM plop
```

ベストプラクティス
``` SQL
WITH plop AS (
    SELECT * FROM foo
)

SELECT a FROM plop
```

## Rule_LT09 : SELECT 句で複数カラムを指定する場合は改行する
アンチパターン
``` SQL
SELECTt a, b
FOM foo

-- カラムが 1 つの場合で改行するとエラーになる
SELECT
    a
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    a,
    b
FROM foo

-- カラムが 1 つの場合は改行しない
SELECT a
FROM foo
```

## Rule_LT10 : SELECT 修飾子（DISTINCTなど）は SELECT と同一行に記載する
アンチパターン
``` SQL
SELECT
    DISTINCT a,
    b
FROM x
```

ベストプラクティス
``` SQL
SELECT DISTINCT
    a,
    b
FROM x
```

## Rule_LT11 : UNION は改行で囲む
アンチパターン
``` SQL
SELECT 'a' AS col UNION ALL
SELECT 'b' AS col
```

ベストプラクティス
``` SQL
SELECT 'a' AS col
UNION ALL
SELECT 'b' AS col
```

## Rule_LT12 : ファイルの末尾には改行のみの行を入れる
アンチパターン
``` SQL
SELECT
    a
FROM foo$

-- インデントのみの行で終わっている

SELECT
••••a
FROM
••••foo
••••$

-- 最終行がセミコロンで終わっているのに、改行がない

SELECT
    a
FROM foo
;$

-- 複数の改行で終わっている

SELECT
    a
FROM foo

$
```

ベストプラクティス
``` SQL
SELECT
    a
FROM foo
$

-- インデントで終わっている場合は、インデントをなくす

SELECT
••••a
FROM
••••foo
$

-- セミコロンの後に改行する

SELECT
    a
FROM foo
;
$
```

## Rule_LT13 : ファイルは改行や space で始めてはいけない
アンチパターン
``` SQL
^

SELECT
    a
FROM foo

-- インデントされた行で始めてもエラーになる
••••SELECT
••••a
FROM
••••foo
```

ベストプラクティス
``` SQL
^SELECT
    a
FROM foo

 -- コメントアウトで始まるのも問題なし
 ^/*
 This is a description of my SQL code.
 */
SELECT
    a
FROM
    foo
```

## Rule_RF01 : FROM 句に存在しないオブジェクトは記載しない
アンチパターン
``` SQL
SELECT
    vee.a
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    a
FROM foo
```

## Rule_RF02 : 複数のテーブルを参照するときは、修飾子を使用する
アンチパターン
``` SQL
SELECT a, b
FROM foo
LEFT JOIN vee ON vee.a = foo.a
```

ベストプラクティス
``` SQL
SELECT foo.a, vee.b
FROM foo
LEFT JOIN vee ON vee.a = foo.a
```

## Rule_RF03 : 修飾子の使用有無は統一する
アンチパターン
``` SQL
SELECT
    a,
    foo.b
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    a,
    b
FROM foo

-- よりいい書き方
SELECT
    foo.a,
    foo.b
FROM foo
```

## Rule_RF04 : 予約語や関数名を修飾子に使用しない
アンチパターン
``` SQL
SELECT
    sum.a
FROM foo AS sum
```

ベストプラクティス
``` SQL
SELECT
    vee.a
FROM foo AS vee
```

## Rule_RF05 : 識別子に特殊文字（「.」「,」「(」「)」「-」以外のもの）を使用しない
アンチパターン
``` SQL
CREATE TABLE DBO.ColumnNames
(
    [Internal Space] INT,
    [Greater>Than] INT,
    [Less<Than] INT,
    Number# INT
)
```

ベストプラクティス
``` SQL
CREATE TABLE DBO.ColumnNames
(
    [Internal_Space] INT,
    [GreaterThan] INT,
    [LessThan] INT,
    NumberVal INT
)
```

## Rule_RF06 : カラム名を不必要に「"」で囲わない
アンチパターン
``` SQL
SELECT 123 AS "foo"
```

ベストプラクティス
``` SQL
SELECT 123 AS foo
```

## Rule_ST01 : CASE 文では、ELSE NULL は冗長なので不要
アンチパターン
``` SQL
SELECT
    CASE
        WHEN name LIKE '%cat%' THEN 'meow'
        WHEN name LIKE '%dog%' THEN 'woof'
        ELSE null
    END
FOM x
```

ベストプラクティス
``` SQL
SELECT
    CASE
        WHEN name LIKE '%cat%' THEN 'meow'
        WHEN name LIKE '%dog%' THEN 'woof'l
    END
FOM x
```

## Rule_ST02 : CASE 文を使用しなくていい場合は使用しない
アンチパターン
``` SQL
SELECT
    CASE
        WHEN fab > 0 THEN TRUE
        ELSE FALSE
    END AS is_fab
FROM fancy_table

-- CASE 文で NULL を埋める場合もエラーになる
SELECT
    CASE
        WHEN fab is null THEN 0
        ELSE fab
    END AS fab_clean
FROM fancy_table
```

ベストプラクティス
``` SQL
SELECT
    COALESCE(fab > 0, FALSE) AS is_fab
FROM fancy_table

-- NULL を埋める場合は COALESCE を使用する
SELECT
    COALESCE(fab, 0) AS fab_clean
FROM fancy_table
```

## Rule_ST03 : 使わない CTE は定義しない
アンチパターン
``` SQL
WITH cte1 AS (
  SELECT a
  FROM t
),
cte2 AS (
  SELECT b
  FROM u
)

SELECT *
FROM cte1
```

ベストプラクティス
``` SQL
WITH cte1 AS (
  SELECT a
  FROM t
)

SELECT *
FROM cte1
```

## Rule_ST04 : CASE 文のネストはばらす
アンチパターン
``` SQL
SELECT
  CASE
    WHEN species = 'Cat' THEN 'Meow'
    ELSE
    CASE
       WHEN species = 'Dog' THEN 'Woof'
    END
  END as sound
FROM mytable
```

ベストプラクティス
``` SQL
SELECT
  CASE
    WHEN species = 'Cat' THEN 'Meow'
    WHEN species = 'Dog' THEN 'Woof'
  END AS sound
FROM mytable
```

## Rule_ST05 : JOIN 句にサブクエリは使用しない、やるなら CTE を使用する
アンチパターン
``` SQL
SELECT
    a.x, a.y, b.z
FROM a
JOIN (
    SELECT x, z FROM b
) USING(x)
```

ベストプラクティス
``` SQL
WITH c AS (
    SELECT x, z FROM b
)

SELECT
    a.x, a.y, c.z
FROM a
JOIN c USING(x)
```

## Rule_ST06 : * を使用する場合は一番最初に記載し単純なものから順に記載する
アンチパターン
``` SQL
SELECT
    a,
    *,
    ROW_NUMBER() OVER(PARTITION BY id ORDER BY date) AS y,
    b
FROM x
```

ベストプラクティス
``` SQL
SELECT
    *,
    a,
    b,
    ROW_NUMBER() OVER(PARTITION BY id ORDER BY date) AS y
FROM x
```

## Rule_ST07 : USING を使用するのではなく、ON を使用する
アンチパターン
``` SQL
SELECT
    table_a.field_1,
    table_b.field_2
FROM
    table_a
INNER JOIN table_b USING (id)
```

ベストプラクティス
``` SQL
SELECT
    table_a.field_1,
    table_b.field_2
FROM
    table_a
INNER JOIN table_b
    ON table_a.id = table_b.id
```

## Rule_ST08 : DISTINCT使用時は括弧で囲まない
アンチパターン
``` SQL
SELECT DISTINCT(a), b FROM foo
```

ベストプラクティス
``` SQL
SELECT DISTINCT a, b FROM foo
```

## Rule_TQ01 : SP_プレフィックスは使用しない（T-SQLのストアドプロシージャには）
アンチパターン
``` SQL
CREATE PROCEDURE dbo.sp_pull_data
AS
SELECT
    ID,
    DataDate,
    CaseOutput
FROM table1
```

ベストプラクティス
``` SQL
CREATE PROCEDURE dbo.pull_data
AS
SELECT
    ID,
    DataDate,
    CaseOutput
FROM table1

-- または USP_プレフィックスを使用する
CREATE PROCEDURE dbo.usp_pull_data
AS
SELECT
    ID,
    DataDate,
    CaseOutput
FROM table1
```
