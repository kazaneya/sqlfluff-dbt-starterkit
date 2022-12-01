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

独自に設定しているルールは L016 の「コメントアウトは Lint の対象から除く」のみです。
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

## Rule_L001 : 末尾の空白は不要

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

## Rule_L002 : 空白に tab と space を混在させない
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

## Rule_L003 : インデントの space は 4 の倍数で統一させる
ON や USING の行頭もインデントをつける

アンチパターン
``` SQL
SELECT
••••a,
•••••b
FROM foo
```

ベストプラクティス
``` SQL
SELECT
••••a,
••••b
FROM foo
```

## Rule_L004 : インデントに tab と space を混在させない
アンチパターン
``` SQL
SELECT
••••a,
→   b
FROM foo
```

ベストプラクティス
``` SQL
SELECT
••••a,
••••b
FROM foo
```

## Rule_L005 : ​​カンマの直前に space を入れない
アンチパターン
``` SQL
SELECT
    a•,
    b
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    a,
    b
FROM foo
```

## Rule_L006 : 演算子は space で囲む
アンチパターン
``` SQL
SELECT
    a +b
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    a + b
FROM foo
```

## Rule_L007 : 演算子の前後で改行を行う場合は改行の後に演算子を使用する
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

## Rule_L008 : コンマの後には space を入れる（コメントが続く場合は除く）
アンチパターン
``` SQL
SELECT
    *
FROM foo
WHERE a IN ('plop','zoo')
```

ベストプラクティス
``` SQL
SELECT
     *
 FROM foo
 WHERE a IN ('plop',•'zoo')
```

## Rule_L009 : ファイルの末尾には改行のみの行を入れる
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

## Rule_L010 : 予約語は大文字で統一する
アンチパターン
``` SQL
select
    a
from foo

– 大文字と小文字が混在している
select
    a
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    a
FROM foo
```

## Rule_L011 : テーブルにエイリアスをつける時は明示的に記載する
アンチパターン
``` SQL
SELECT
    voo.a
FROM foo voo
```

ベストプラクティス
``` SQL
SELECT
    voo.a
FROM foo AS voo
```

## Rule_L012 : カラムにエイリアスをつける時は明示的に記載する
アンチパターン
``` SQL
SELECT
    a alias_col
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    a AS alias_col
FROM foo
```

## Rule_L013 : 関数を使用したカラムは明示的に命名する
アンチパターン
``` SQL
SELECT
    sum(a),
    sum(b)
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    sum(a) AS a_sum,
    sum(b) AS b_sum
FROM foo
```

## Rule_L014 : カラム名は小文字に統一する
アンチパターン
``` SQL
SELECT
    A,
    B
FROM foo

– 大文字と小文字が混在している
SELECT
    a,
    B
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    a,
    b
FROM foo
```

## Rule_L015 : DISTINCT使用時は括弧で囲まない
アンチパターン
``` SQL
SELECT DISTINCT(a), b FROM foo
```

ベストプラクティス
``` SQL
SELECT DISTINCT a, b FROM foo
```

## Rule_L016 : コメント行以外は 100 文字以内にする

## Rule_L017 : 関数名の直後に括弧を記載する
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

## Rule_L018 : WITH 句の閉じ括弧は、WITH とインデントを揃える
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

## Rule_L019 : コンマは行末に記載する
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

## Rule_L020 : テーブルエイリアスは、各句内で一意にする
アンチパターン
``` SQL
SELECT
    t.a,
    t.b
FROM foo AS t, bar AS t

-- 以下のような記述でもエラーになる

SELECT
    a,
    b
FROM
    2020.foo,
    2021.foo
```

ベストプラクティス
``` SQL
SELECT
    f.a,
    b.b
FROM foo AS f, bar AS b

-- 明示的に記載する

SELECT
    f1.a,
    f2.b
FROM
    2020.foo AS f1,
    2021.foo AS f2
```

## Rule_L021 : DISTINCT と GROUP BY は同時に使用しない
アンチパターン
``` SQL
SELECT DISTINCT
    a
FROM foo
GROUP BY a
```

ベストプラクティス
``` SQL
SELECT DISTINCT
    a
FROM foo
```

## Rule_L022 : CTE の閉じ括弧の後は改行する
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

## Rule_L023 : WITH 句の AS の後に space を入れる
アンチパターン
``` SQL
WITH plop AS(
    SELECT * FROM foo
)

SELECT a FROM plop
```

ベストプラクティス
``` SQL
WITH plop AS•(
    SELECT * FROM foo
)

SELECT a FROM plop
```

## Rule_L024 : JOIN 句では USING の後に space を入れる
アンチパターン
``` SQL
SELECT b
FROM foo
LEFT JOIN zoo USING(a)
```

ベストプラクティス
``` SQL
SELECT b
FROM foo
LEFT JOIN zoo USING (a)
```

## Rule_L025 : テーブルのエイリアスをつける場合は、他の箇所でそのエイリアスを使用する
アンチパターン
``` SQL
SELECT
    a
FROM foo AS zoo
```

ベストプラクティス
``` SQL
SELECT
    zoo.a
FROM foo AS zoo

-- あるいは.

SELECT
    a
FROM foo
```

## Rule_L026 : FROM 句に存在しないオブジェクトは記載しない
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

## Rule_L027 : 複数のテーブルを参照するときは、修飾子を使用する
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

## Rule_L028 : 修飾子の使用有無は統一する
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

## Rule_L029 : 予約語や関数名を修飾子に使用しない
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

## Rule_L030 : 関数名は大文字に統一する
アンチパターン
``` SQL
SELECT
    sum(a) AS aa,
    sum(b) AS bb
FROM foo

– 大文字と小文字が混在している
SELECT
    sum(a) AS aa,
    SUM(b) AS bb
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    SUM(a) AS aa,
    SUM(b) AS bb
FROM foo
```

## Rule_L031 : FROM 句とJOIN 句ではテーブルのエイリアスは使わない
アンチパターン
``` SQL
SELECT
    COUNT(o.customer_id) as order_amount,
    c.name
FROM orders as o
JOIN customers as c on o.id = c.user_id
```

ベストプラクティス
``` SQL
SELECT
    COUNT(orders.customer_id) as order_amount,
    customers.name
FROM orders
JOIN customers on orders.id = customers.user_id

-- 以下パターンは OK
SELECT
    table1.a,
    table_alias.b,
FROM
    table1
    LEFT JOIN table1 AS table_alias ON
        table1.foreign_key = table_alias.foreign_key
```

## Rule_L032 : USING を使用するのではなく、ON を使用する
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

## Rule_L033 : UNION を使用するときは DISTINCT か ALL をつける
アンチパターン
``` SQL
SELECT a, b FROM table_1
UNION
SELECT a, b FROM table_2
```

ベストプラクティス
``` SQL
SELECT a, b FROM table_1
UNION DISTINCT
SELECT a, b FROM table_2
```

## Rule_L034 : * を使用する場合は一番最初に記載し単純なものから順に記載する
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

## Rule_L035 : CASE 文では、ELSE NULL は冗長なので不要
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

## Rule_L036 : SELECT 句で複数カラムを指定する場合は改行する
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

## Rule_L037 : ORDER BY では指定カラムそれぞれに ASC か DESC を必ずつける
アンチパターン
``` SQL
SELECT
    a, b
FROM foo
ORDER BY a, b DESC
```

ベストプラクティス
``` SQL
SELECT
    a, b
FROM foo
ORDER BY a ASC, b DESC
```

## Rule_L038 : SELECT 句の末尾にコンマはつけない
アンチパターン
``` SQL
SELECT
    a,
    b,
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    a,
    b
FROM foo
```

## Rule_L039 : 不要な space は使用しない
アンチパターン
``` SQL
SELECT
    a,        b
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    a, b
FROM foo
```

## Rule_L040 : NULL, TRUE, FALSE は大文字で統一する
アンチパターン
``` SQL
SELECT
    a,
    null,
    true,
    false
FROM foo

– 大文字と小文字が混在している
SELECT
    a,
    null,
    TRUE,
    false
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    a,
    NULL,
    TRUE,
    FALSE
FROM foo
```

## Rule_L041 : SELECT 修飾子（DISTINCTなど）は SELECT と同一行に記載する
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

## Rule_L042 : JOIN 句にサブクエリは使用しない、やるなら CTE を使用する
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

## Rule_L043 : CASE 文を使用しなくていい場合は使用しない
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

## Rule_L044 : 結果のカラムの数が分かるようにする
アンチパターン
``` SQL
WITH cte AS (
    SELECT * FROM foo
)

SELECT * FROM cte
UNION
SELECT a, b FROM t
```

ベストプラクティス
``` SQL
WITH cte AS (
    SELECT * FROM foo
)

SELECT a, b FROM cte
UNION
SELECT a, b FROM t
```

## Rule_L045 : 使わない CTE は定義しない
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

## Rule_L046 : Jinja のタグは 1 つずつの space で囲む
アンチパターン
``` SQL
 SELECT {{    a     }} from {{ref('foo')}}
```

ベストプラクティス
``` SQL
SELECT {{ a }} from {{ ref('foo') }};
SELECT {{ a }} from {{
    ref('foo')
}};
```

## Rule_L047 : 行数をカウントする場合は COUNT(*) を使用する
アンチパターン
``` SQL
SELECT
    COUNT(1)
FROM table_a
```

ベストプラクティス
``` SQL
SELECT
    COUNT(*)
FROM table_a
```

## Rule_L048 : 引用符「'」は 1 つずつの space で囲む
アンチパターン
``` SQL
SELECT
    'foo'AS bar
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    'foo' AS bar
FROM foo
```

## Rule_L049 : NULL との比較では、「IS」または「IS NOT」を使用する
アンチパターン
``` SQL
SELECT
    a
FROM foo
WHERE a = NULL
```

ベストプラクティス
``` SQL
SELECT
    a
FROM foo
WHERE a IS NULL
```

## Rule_L050 : ファイルは改行や space で始めてはいけない
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

## Rule_L051 : JOIN には「INNER, LEFT, RIGHT, FULL OUTER」を明記する
アンチパターン
``` SQL
SELECT
    foo
FROM bar
JOIN baz;
```

ベストプラクティス
``` SQL
SELECT
    foo
FROM bar
INNER JOIN baz;
```

## Rule_L052 : セミコロンを使用する場合は最後に記載し、セミコロンの前に改行や space を入れない
アンチパターン
``` SQL
SELECT
    a
FROM foo

;

SELECT
    b
FROM bar••;
```

ベストプラクティス
``` SQL
SELECT
    a
FROM foo;
```

## Rule_L053 : TOP レベルの SQL は（）で囲まない
アンチパターン
``` SQL
(SELECT
    foo
FROM bar)

-- サブクエリを使用する場合でもエラーになる
(SELECT
    foo
FROM (SELECT * FROM bar))
```

ベストプラクティス
``` SQL
SELECT
    foo
FROM bar

-- サブクエリのみ括弧を使用する
SELECT
    foo
FROM (SELECT * FROM bar)
```

## Rule_L054 : GROUP BY や ORDER BY はポジション表記（1,2...）で統一する
アンチパターン
``` SQL
SELECT
    foo,
    bar,
    SUM(baz) AS sum_value
FROM fake_table
GROUP BY
    foo, bar
ORDER BY
    foo, bar;

– カラム名とポジション表記が混在している
SELECT
    foo,
    bar,
    SUM(baz) AS sum_value
FROM fake_table
GROUP BY
    foo, 2
    1, bar;
```

ベストプラクティス
``` SQL
SELECT
    foo,
    bar,
    SUM(baz) AS sum_value
FROM fake_table
GROUP BY
     1, 2
ORDER BY
    1, 2;

```

## Rule_L055 : RIGHTJOIN の代わりに LEFTJOIN を使用する
アンチパターン
``` SQL
SELECT
    foo.col1,
    bar.col2
FROM foo
RIGHT JOIN bar
    ON foo.bar_id = bar.id;
```

ベストプラクティス
``` SQL
SELECT
    foo.col1,
    bar.col2
FROM bar
LEFT JOIN foo
    ON foo.bar_id = bar.id;
```

## Rule_L056 : SP_プレフィックスは使用しない（T-SQLのストアドプロシージャには）
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

## Rule_L057 : 識別子に特殊文字（「.」「,」「(」「)」「-」以外のもの）を使用しない
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

## Rule_L058 : CASE 文のネストはばらす
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

## Rule_L059 : カラム名を不必要に「"」で囲わない
アンチパターン
``` SQL
SELECT 123 AS "foo"
```

ベストプラクティス
``` SQL
SELECT 123 AS foo
```

## Rule_L060 : IFNULL や NVL の代わりに COALESCE を使用する
アンチパターン
``` SQL
SELECT IFNULL(foo, 0) AS bar,
FROM baz;

SELECT NVL(foo, 0) AS bar,
FROM baz;
```

ベストプラクティス
``` SQL
SELECT COALESCE(foo, 0) AS bar,
FROM baz;
```

## Rule_L061 : 「等しくない」には、<> の代​​わりに != を使用する
アンチパターン
``` SQL
SELECT * FROM X WHERE 1 <> 2;
```

ベストプラクティス
``` SQL
SELECT * FROM X WHERE 1 != 2;
```

## Rule_L062 : 設定なし

## Rule_L063 : データ型は大文字で統一する
アンチパターン
``` SQL
CREATE TABLE t (
    a int unsigned,
    b VARCHAR(15)
);
```

ベストプラクティス
``` SQL
CREATE TABLE t (
    a INT UNSIGNED,
    b VARCHAR(15)
);
```

## Rule_L064 : 「'」「"」の使用は統一性を持たせる
アンチパターン
``` SQL
SELECT
    "abc",
    'abc',
    "\",
    "abc" = 'abc'
FROM foo
```

ベストプラクティス
``` SQL
SELECT
    "abc",
    "abc",
    '\"',
    "abc" = "ab"
FROM foo
```

## Rule_L065 : UNION は改行で囲む
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
