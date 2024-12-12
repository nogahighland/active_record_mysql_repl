# ActiveRecordMysqlRepl

## Prerequisites

### Ruby version 3.0.0 or higher

e.g) Using rbenv

```bash
$ rbenv install 3.3.6
```

### mysql-client 8.0

e.g) on macOS

```bash
$ brew install mysql-client@8.0
$ gem install mysql2 -v 0.5.6 -- --with-ldflags=-L$(brew --prefix zstd)/lib --with-mysql-dir=/opt/homebrew/opt/mysql-client@8.4
```

## Installation

Just by installing the gem, you can use the `army` command.

```bash
$ gem install active_record_mysql_repl
Successfully installed active_record_mysql_repl-x.x.x
Parsing documentation for active_record_mysql_repl-x.x.x
Installing ri documentation for active_record_mysql_repl-x.x.x
Done installing documentation for active_record_mysql_repl after 0 seconds
1 gem installed
```

```
$ army
ActiveRecordMysqlRepl Version: x.x.x
```

If you want to use the zsh completion, you can add the following line to your `.zshrc` file.

```sh
$ eval "$(army --zsh-completion)"
```

Then you can use the completion feature like below.

```sh
$ army [TAB]
option
-c  -- path to .armyrc file
-d  -- Database name
-e  -- output erd
```

## Usage

### Sample Configurations

From the following link, you can Download the sample configuration files
https://github.com/nogahighland/active_record_mysql_repl/tree/main/sample_config

Also you can try with sample database on your local MySQL server
https://github.com/nogahighland/active_record_mysql_repl/blob/main/sample_config/sample_db.sql

### Sample Database

```sql
CREATE DATABASE test;
```

The sample configuration assumes the sample database is running on
127.0.0.1:3306/test (user: root, password: root)

```
$ mysql -u root -p test < sample_db.sql
```

### Showcases

```sh
army -c /path/to/sample_config/.army.sample.yml -d test
Ensureing connection to test on port 127.0.0.1:33060
Loading tables
Loading custom extensions from /path/to/sample_config/./.army.sample/extensions
```

Now you can access to the table classes as `User` if the table name is `users`.

```rb
[1] test(main)> User.all
```

<details><summary>output:</summary>

```rb
D, [2024-12-12T12:57:38.581127 #2816] DEBUG -- :   User Load (10.5ms)  SELECT `users`.* FROM `users`
[
  [0] #<User:0x0000000123188de0> {
    :id         => "1",
    :login_id   => "user1",
    :profile_id => 1
  }
]
```

</details>

---

`.d` method shows the schema of the table. Let's see the `Order` table schema.

```rb
[8] test(main)> Order.d
```

<details><summary>output:</summary>

```
D, [2024-12-12T12:32:20.100309 #2816] DEBUG -- :    (10.6ms)  DESCRIBE orders
D, [2024-12-12T12:32:20.107976 #2816] DEBUG -- :    (6.9ms)  SHOW INDEX FROM orders
# orders
+---------+-------------+------+-----+---------+-------+
| Field   | Type        | Null | Key | Default | Extra |
+---------+-------------+------+-----+---------+-------+
| id      | varchar(64) | NO   | PRI |         |       |
| user_id | varchar(64) | NO   |     |         |       |
| item_id | varchar(64) | NO   |     |         |       |
+---------+-------------+------+-----+---------+-------+
+--------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table  | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+--------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| orders | 0          | PRIMARY  | 1            | id          | A         | 1           |          |        |      | BTREE      |         |               | YES     |            |
+--------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
```

</details>

---

`.ddl` method shows the DDL of the table.

```rb
[9] test(main)> Order.ddl
```

<details><summary>output:</summary>

```
D, [2024-12-12T12:32:21.878444 #2816] DEBUG -- :    (8.7ms)  SHOW CREATE TABLE orders
CREATE TABLE `orders` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `item_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin
```

</details>

---

`models` is globally defined to get and array of all the table classes. By `.map(&:d)` you can see the schema of all the tables.

https://github.com/nogahighland/active_record_mysql_repl/blob/main/lib/active_record_mysql_repl/extensions/global.rb#L10-L12

```rb
[6] test(main)> puts models.map(&:d)
```

<details><summary>output:</summary>

```
D, [2024-12-12T01:26:36.677988 #25446] DEBUG -- :   Brand Load (2.1ms)  SELECT `brands`.* FROM `brands`
D, [2024-12-12T01:26:36.681307 #25446] DEBUG -- :   Category Load (2.8ms)  SELECT `categories`.* FROM `categories`
D, [2024-12-12T01:26:36.683967 #25446] DEBUG -- :   Item Load (2.0ms)  SELECT `items`.* FROM `items`
D, [2024-12-12T01:26:36.687282 #25446] DEBUG -- :   Order Load (3.0ms)  SELECT `orders`.* FROM `orders`
D, [2024-12-12T01:26:36.691204 #25446] DEBUG -- :   UserProfile Load (3.6ms)  SELECT `user_profiles`.* FROM `user_profiles`
D, [2024-12-12T01:26:36.694081 #25446] DEBUG -- :   User Load (2.2ms)  SELECT `users`.* FROM `users`
# users
+------------+-------------+------+-----+---------+-------+
| Field      | Type        | Null | Key | Default | Extra |
+------------+-------------+------+-----+---------+-------+
| id         | varchar(64) | NO   | PRI |         |       |
| login_id   | varchar(64) | NO   |     |         |       |
| profile_id | int         | YES  |     |         |       |
+------------+-------------+------+-----+---------+-------+
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| users | 0          | PRIMARY  | 1            | id          | A         | 1           |          |        |      | BTREE      |         |               | YES     |            |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
# user_profiles
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | varchar(64) | NO   | PRI |         |       |
| name  | varchar(64) | NO   |     |         |       |
+-------+-------------+------+-----+---------+-------+
+---------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table         | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+---------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| user_profiles | 0          | PRIMARY  | 1            | id          | A         | 1           |          |        |      | BTREE      |         |               | YES     |            |
+---------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
# orders
+---------+-------------+------+-----+---------+-------+
| Field   | Type        | Null | Key | Default | Extra |
+---------+-------------+------+-----+---------+-------+
| id      | varchar(64) | NO   | PRI |         |       |
| user_id | varchar(64) | NO   |     |         |       |
| item_id | varchar(64) | NO   |     |         |       |
+---------+-------------+------+-----+---------+-------+
+--------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table  | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+--------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| orders | 0          | PRIMARY  | 1            | id          | A         | 1           |          |        |      | BTREE      |         |               | YES     |            |
+--------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
# items
+-------------+-------------+------+-----+---------+-------+
| Field       | Type        | Null | Key | Default | Extra |
+-------------+-------------+------+-----+---------+-------+
| id          | varchar(64) | NO   | PRI |         |       |
| category_id | varchar(64) | NO   |     |         |       |
| brand_id    | varchar(64) | NO   |     |         |       |
+-------------+-------------+------+-----+---------+-------+
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| items | 0          | PRIMARY  | 1            | id          | A         | 1           |          |        |      | BTREE      |         |               | YES     |            |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
# categories
+-----------+-------------+------+-----+---------+-------+
| Field     | Type        | Null | Key | Default | Extra |
+-----------+-------------+------+-----+---------+-------+
| id        | varchar(64) | NO   | PRI |         |       |
| name      | varchar(64) | NO   |     |         |       |
| parent_id | varchar(64) | NO   |     |         |       |
+-----------+-------------+------+-----+---------+-------+
+------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table      | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| categories | 0          | PRIMARY  | 1            | id          | A         | 2           |          |        |      | BTREE      |         |               | YES     |            |
+------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
# brands
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | varchar(64) | NO   | PRI |         |       |
| name  | varchar(64) | NO   |     |         |       |
+-------+-------------+------+-----+---------+-------+
+--------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table  | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+--------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| brands | 0          | PRIMARY  | 1            | id          | A         | 1           |          |        |      | BTREE      |         |               | YES     |            |
+--------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
```

</details>

---

To get the last record of order,

```rb
[1] test(main)> Order.last
```

<details><summary>output:</summary>

```rb
D, [2024-12-11T23:45:49.743857 #96076] DEBUG -- :   Order Load (5.5ms)  SELECT `orders`.* FROM `orders` ORDER BY `orders`.`id` DESC LIMIT 1
#<Order:0x00000001293677c8> {
  :id      => "1",
  :user_id => "1",
  :item_id => "1"
}
```

</details>

---

You can get the last order's user because `user_id` column exists on `orders` table. For the same reason you can get the order's item and its category too.
All the associations are chainable by the native functionality of ActiveRecord.

```rb
[5] test(main)> Order.last.user
```

<details><summary>output:</summary>

```rb
D, [2024-12-11T23:46:11.154678 #96076] DEBUG -- :   Order Load (6.9ms)  SELECT `orders`.* FROM `orders` ORDER BY `orders`.`id` DESC LIMIT 1
D, [2024-12-11T23:46:11.176424 #96076] DEBUG -- :   User Load (2.9ms)  SELECT `users`.* FROM `users` WHERE `users`.`id` = '1' LIMIT 1
#<User:0x000000012961fda8> {
  :id         => "1",
  :login_id   => "user1",
  :profile_id => 1
}
```

</details>

```rb
[7] test(main)> Order.last.item
```

<details><summary>output:</summary>

```rb
D, [2024-12-11T23:46:17.098874 #96076] DEBUG -- :   Order Load (3.5ms)  SELECT `orders`.* FROM `orders` ORDER BY `orders`.`id` DESC LIMIT 1
D, [2024-12-11T23:46:17.112940 #96076] DEBUG -- :   Item Load (2.2ms)  SELECT `items`.* FROM `items` WHERE `items`.`id` = '1' LIMIT 1
#<Item:0x000000012a416c40> {
  :id          => "1",
  :category_id => "2",
  :brand_id    => "1"
}
```

</details>

```rb
[8] test(main)> Order.last.item.category
```

<details><summary>output:</summary>

```rb
D, [2024-12-11T23:46:21.104696 #96076] DEBUG -- :   Order Load (2.1ms)  SELECT `orders`.* FROM `orders` ORDER BY `orders`.`id` DESC LIMIT 1
D, [2024-12-11T23:46:21.106696 #96076] DEBUG -- :   Item Load (1.5ms)  SELECT `items`.* FROM `items` WHERE `items`.`id` = '1' LIMIT 1
D, [2024-12-11T23:46:21.117169 #96076] DEBUG -- :   Category Load (2.5ms)  SELECT `categories`.* FROM `categories` WHERE `categories`.`id` = '2' LIMIT 1
#<Category:0x000000012a5d7b38> {
  :id        => "2",
  :name      => "category2",
  :parent_id => "1"
}
```

</details>

---

A category's parent is fetched from the same table because `parent_id`'s `parent` is treated by `ActiveRecordMysqlRepl` as inplicitly pointing to the same table.

```rb
[9] test(main)> Order.last.item.category.parent
```

<details><summary>output:</summary>

```rb
D, [2024-12-11T23:46:23.553443 #96076] DEBUG -- :   Order Load (2.0ms)  SELECT `orders`.* FROM `orders` ORDER BY `orders`.`id` DESC LIMIT 1
D, [2024-12-11T23:46:23.555918 #96076] DEBUG -- :   Item Load (2.1ms)  SELECT `items`.* FROM `items` WHERE `items`.`id` = '1' LIMIT 1
D, [2024-12-11T23:46:23.560142 #96076] DEBUG -- :   Category Load (3.8ms)  SELECT `categories`.* FROM `categories` WHERE `categories`.`id` = '2' LIMIT 1
D, [2024-12-11T23:46:23.562496 #96076] DEBUG -- :   Category Load (1.3ms)  SELECT `categories`.* FROM `categories` WHERE `categories`.`id` = '1' LIMIT 1
#<Category:0x000000012a73dd60> {
  :id        => "1",
  :name      => "category1",
  :parent_id => ""
}
```

</details>

---

You can get user's profile by `.profile` because the custom association is defined here

https://github.com/nogahighland/active_record_mysql_repl/blob/main/sample_config/.army.sample/associations.sample.yml#L4-L8

```rb
[6] test(main)> Order.last.user.profile
```

<details><summary>output:</summary>

```rb
D, [2024-12-11T23:46:13.637188 #96076] DEBUG -- :   Order Load (2.4ms)  SELECT `orders`.* FROM `orders` ORDER BY `orders`.`id` DESC LIMIT 1
D, [2024-12-11T23:46:13.642210 #96076] DEBUG -- :   User Load (4.6ms)  SELECT `users`.* FROM `users` WHERE `users`.`id` = '1' LIMIT 1
D, [2024-12-11T23:46:13.643998 #96076] DEBUG -- :   User Load (1.3ms)  SELECT `users`.* FROM `users` WHERE `users`.`id` = '1' LIMIT 1
#<User:0x000000012a73f2a0> {
  :id         => "1",
  :login_id   => "user1",
  :profile_id => 1
}
```

</details>

---



```rb
[10] test(main)> Order.last.item.brand
```

<details><summary>output:</summary>

```rb
D, [2024-12-11T23:46:28.715219 #96076] DEBUG -- :   Order Load (4.1ms)  SELECT `orders`.* FROM `orders` ORDER BY `orders`.`id` DESC LIMIT 1
D, [2024-12-11T23:46:28.717319 #96076] DEBUG -- :   Item Load (1.7ms)  SELECT `items`.* FROM `items` WHERE `items`.`id` = '1' LIMIT 1
D, [2024-12-11T23:46:28.731254 #96076] DEBUG -- :   Brand Load (3.1ms)  SELECT `brands`.* FROM `brands` WHERE `brands`.`id` = '1' LIMIT 1
#<Brand:0x000000012a411ab0> {
  :id   => "1",
  :name => "brand1"
}
```

</details>

---

By `tab` (an alias to `tabulate`), the filtered records are shown in a table format. `.tab(orientation)` accepts the `:h(orizontal)` (default when <5 columns), and `:v(ertival)` (default when >=5 columns)

https://github.com/nogahighland/active_record_mysql_repl/blob/9f7c91774b176e1204ed434dad2867721982c660/lib/active_record_mysql_repl/extensions/object.rb#L11

```rb
[3] test(main)> Order.all.tab
```

<details><summary>output:</summary>

```rb
D, [2024-12-11T23:48:46.013935 #96381] DEBUG -- :   Order Load (2.2ms)  SELECT `orders`.* FROM `orders`
+----+---------+---------+
| id | user_id | item_id |
+----+---------+---------+
| 1  | 1       | 1       |
+----+---------+---------+
```

</details>

---

```rb
[4] test(main)> Order.all.tab(:v)
```

<details><summary>output:</summary>

```rb
D, [2024-12-11T23:48:49.461243 #96381] DEBUG -- :   Order Load (3.2ms)  SELECT `orders`.* FROM `orders`
+---------+-------+
| Name    | Value |
+---------+-------+
| id      | 1     |
| user_id | 1     |
| item_id | 1     |
+---------+-------+
```

</details>

---

`.j` is aliased to `.to_json` and `.jp` is defined to generate pretty json.

https://github.com/nogahighland/active_record_mysql_repl/blob/9f7c91774b176e1204ed434dad2867721982c660/lib/active_record_mysql_repl/extensions/object.rb#L128-L132

```rb
[5] test(main)> Order.all.j
```

<details><summary>output:</summary>

```rb
D, [2024-12-11T23:48:55.267761 #96381] DEBUG -- :   Order Load (4.4ms)  SELECT `orders`.* FROM `orders`
[{"id":"1","user_id":"1","item_id":"1"}]
```

</details>

```rb
[6] test(main)> Order.all.jp
```

<details><summary>output:</summary>

```rb
D, [2024-12-11T23:48:57.250492 #96381] DEBUG -- :   Order Load (1.8ms)  SELECT `orders`.* FROM `orders`
[
  {
    "id": "1",
    "user_id": "1",
    "item_id": "1"
  }
]
```

</details>

---

`.csv(orientation)` is defined to generate csv format. The default orientation is same as `.tab`.

https://github.com/nogahighland/active_record_mysql_repl/blob/9f7c91774b176e1204ed434dad2867721982c660/lib/active_record_mysql_repl/extensions/object.rb#L71

```rb
[1] test(main)> Order.all.csv
```

<details><summary>output:</summary>

```
D, [2024-12-12T01:29:12.844339 #26252] DEBUG -- :   Order Load (2.7ms)  SELECT `orders`.* FROM `orders`
id,user_id,item_id
1,1,1
```

</details>

---

`.cp` is defined to copy to clipboard the receiver object's `.to_s` representation.

```rb
[7] test(main)> Order.all.jp.cp
```

<details><summary>output:</summary>

```rb
D, [2024-12-11T23:48:59.443202 #96381] DEBUG -- :   Order Load (2.0ms)  SELECT `orders`.* FROM `orders`
true
```

</details>

---

`.exec_sql` is defined to execute the sql query and return the result as an array of hash.

```rb
[8] test(main)> exec_sql('select 1')
```

<details><summary>output:</summary>

```rb
D, [2024-12-11T23:49:15.879841 #96381] DEBUG -- :    (1.2ms)  select 1
[
  [0] {
    "1" => 1
  }
]
```

</details>

---

```rb
[9] test(main)> exec_sql('select 1').tab
```

<details><summary>output:</summary>

```rb
D, [2024-12-11T23:49:17.187358 #96381] DEBUG -- :    (2.1ms)  select 1
+---+
| 1 |
+---+
| 1 |
+---+
```

</details>

---

```rb
[10] test(main)> exec_sql('select 1 as num').tab
```

<details><summary>output:</summary>

```
D, [2024-12-11T23:49:22.406631 #96381] DEBUG -- :    (1.3ms)  select 1 as num
+-----+
| num |
+-----+
| 1   |
+-----+
```

</details>

---

You can define your own extension script. For example `.upcase_name` is defined on `UserProfile` by the sample extension which is specified in the `.army.sample.yml` file.

- https://github.com/nogahighland/active_record_mysql_repl/blob/9f7c91774b176e1204ed434dad2867721982c660/sample_config/.army.sample.yml#L5
- https://github.com/nogahighland/active_record_mysql_repl/blob/main/sample_config/.army.sample/extensions/hello.rb

```rb
[3] test(main)> UserProfile.last.upcase_name
```

<details><summary>output:</summary>

```
D, [2024-12-12T12:09:10.987656 #60808] DEBUG -- :   UserProfile Load (1.7ms)  SELECT `user_profiles`.* FROM `user_profiles` ORDER BY `user_profiles`.`id` DESC LIMIT 1
USER1
```

</details>

---

## Development

TODO

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nogahifhland/active_record_mysql_repl. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/nogahighland/active_record_mysql_repl/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveRecordMysqlRepl project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/active_record_mysql_repl/blob/main/CODE_OF_CONDUCT.md).
