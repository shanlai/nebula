# Copyright (c) 2020 vesoft inc. All rights reserved.
#
# This source code is licensed under Apache 2.0 License.
Feature: match Prune properties

  Background:
    Given a graph with space named "nba"

  Scenario: match single vertex:
    Given having executed:
      """
      ALTER TAG player ADD (sex string NOT NULL DEFAULT "男");
      ALTER EDGE like ADD (start_year int64 NOT NULL DEFAULT 2022);
      ALTER EDGE serve ADD (degree int64 NOT NULL DEFAULT 88);
      ALTER EDGE follow ADD (start_year int64 NOT NULL DEFAULT 2022);
      """
    And wait 6 seconds
    When executing query:
      """
      match (v) return properties(v).name limit 2;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(v).name  |
      | "Amar'e Stoudemire" |
      | "Carmelo Anthony"   |
    When executing query:
      """
      match (v:player) return properties(v).name limit 2;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(v).name  |
      | "Amar'e Stoudemire" |
      | "Carmelo Anthony"   |
    When executing query:
      """
      match (v:player) return properties(v).name,v.player.age limit 2;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(v).name  | v.player.age |
      | "Amar'e Stoudemire" | 36           |
      | "Carmelo Anthony"   | 34           |
    When executing query:
      """
      match (v:player) where properties(v).name ==  "LaMarcus Aldridge" return properties(v).age;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(v).age |
      | 33                |
    When executing query:
      """
      match (v:player) where properties(v).name ==  "LaMarcus Aldridge" return v.player.age;
      """
    Then the result should be, in any order, with relax comparison:
      | v.player.age |
      | 33           |
    When executing query:
      """
      match (v:player) where properties(v).name=="LaMarcus Aldridge" return v.player.sex,properties(v).age;
      """
    Then the result should be, in any order, with relax comparison:
      | v.player.sex | v.player.age |
      | "男"         | 33           |
    When executing query:
      """
      match (v:player) where id(v)=="Carmelo Anthony" return v.player.age;
      """
    Then the result should be, in any order, with relax comparison:
      | v.player.age |
      | 34           |
    When executing query:
      """
      match (v:player) where id(v)=="Carmelo Anthony" return v.player.age;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(v).age |
      | 34                |
    When executing query:
      """
      match (v:player) where id(v)=="Carmelo Anthony" return properties(v).age,v.player.sex;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(v).age | v.player.sex |
      | 34                | "男"         |
    When executing query:
      """
      match (v:player{name:"LaMarcus Aldridge"}) return v.player.age;
      """
    Then the result should be, in any order, with relax comparison:
      | v.player.age |
      | 33           |
    When executing query:
      """
      match (v:player{name:"LaMarcus Aldridge"}) return properties(v).age;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(v).age |
      | 33                |
    When executing query:
      """
      match (v:player{name:"LaMarcus Aldridge"}) return properties(v).age,v.player.sex;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(v).age | v.player.sex |
      | 33                | "男"         |
    When executing query:
      """
      match (v:player) return id(v),properties(v).name,v.player.age limit 2;
      """
    Then the result should be, in any order, with relax comparison:
      | id(v)               | properties(v).name  | v.player.age |
      | "Amar'e Stoudemire" | "Amar'e Stoudemire" | 36           |
      | "Carmelo Anthony"   | "Carmelo Anthony"   | 34           |
    When executing query:
      """
      match (v) return id(v),properties(v).name,v.player.age limit 2;
      """
    Then the result should be, in any order, with relax comparison:
      | id(v)               | properties(v).name  | v.player.age |
      | "Amar'e Stoudemire" | "Amar'e Stoudemire" | 36           |
      | "Carmelo Anthony"   | "Carmelo Anthony"   | 34           |

  Scenario: match single edge
    When executing query:
      """
      match ()-[e]->() return properties(e).start_year limit 2;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(e).start_year |
      | 2022                     |
      | 2015                     |
    When executing query:
      """
      match ()-[e:serve]->() return properties(e).start_year limit 2;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(e).start_year |
      | 2015                     |
      | 1994                     |
    When executing query:
      """
      match ()-[e:serve]->() return properties(e).start_year,e.end_year limit 2;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(e).start_year | e.end_year |
      | 2015                     | 2017       |
      | 1994                     | 2000       |
    When executing query:
      """
      match ()-[e:serve]->() where e.start_year>1022 return properties(e).end_year limit 2;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(e).end_year |
      | 2017                   |
      | 2000                   |
    When executing query:
      """
      match ()-[e:serve]->() where e.start_year>1022 return e.end_year limit 2;
      """
    Then the result should be, in any order, with relax comparison:
      | e.end_year |
      | 2017       |
      | 2000       |
    When executing query:
      """
      match ()-[e:serve]->() where e.start_year>1022 return e.end_year,properties(e).degree limit 2;
      """
    Then the result should be, in any order, with relax comparison:
      | e.end_year | properties(e).degree |
      | 2017       | 88                   |
      | 2000       | 88                   |
    When executing query:
      """
      match ()-[e:serve]->() where e.start_year>1022 return e.end_year limit 2;
      """
    Then the result should be, in any order, with relax comparison:
      | e.end_year |
      | 2017       |
      | 2000       |
    When executing query:
      """
      match ()-[e:serve]->() where e.start_year>1022 return properties(e).degree limit 2;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(e).degree |
      | 88                   |
      | 88                   |
    When executing query:
      """
      match ()-[e:serve]->() where e.start_year>1022 return e.end_year,properties(e).degree limit 2;
      """
    Then the result should be, in any order, with relax comparison:
      | e.end_year | properties(e).degree |
      | 2017       | 88                   |
      | 2000       | 88                   |
    When executing query:
      """
      match ()-[e:serve{degree:88}]->()  return properties(e).start_year limit 2;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(e).start_year |
      | 2015                     |
      | 1994                     |
    When executing query:
      """
      match ()-[e:serve{degree:88}]->()  return e.end_year limit 2;
      """
    Then the result should be, in any order, with relax comparison:
      | e.end_year |
      | 2017       |
      | 2000       |
    When executing query:
      """
      match ()-[e:serve{degree:88}]->()  return e.end_year,properties(e).start_year limit 2;
      """
    Then the result should be, in any order, with relax comparison:
      | e.end_year | properties(e).start_year |
      | 2017       | 2015                     |
      | 2000       | 1994                     |

  Scenario: match complex pattern
    When executing query:
      """
      match (src_v:player{name:"Manu Ginobili"})-[e]-(dst_v) return properties(src_v).age,properties(e).degree,properties(dst_v).name,src_v.player.sex,e.start_year,dst_v.player.age limit 3;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(src_v).age | properties(e).degree | properties(dst_v).name | src_v.player.sex | e.start_year | dst_v.player.age |
      | 41                    | 88                   | "Spurs"                | "男"             | 2002         | __NULL__         |
      | 41                    | 88                   | "Dejounte Murray"      | "男"             | 2022         | 29               |
      | 41                    | 88                   | "Tiago Splitter"       | "男"             | 2022         | 34               |
    When executing query:
      """
      match (src_v:player{name:"Manu Ginobili"})-[e*2]-(dst_v) return properties(src_v).sex,properties(e[0]).degree,properties(dst_v).name,src_v.player.age, e[1].start_year,dst_v.player.age limit 5;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(src_v).sex | properties(e[0]).degree | properties(dst_v).name | src_v.player.age | e[1].start_year | dst_v.player.age |
      | "男"                  | 88                      | "Tracy McGrady"        | 41               | 2013            | 39               |
      | "男"                  | 88                      | "Rudy Gay"             | 41               | 2017            | 32               |
      | "男"                  | 88                      | "Paul Gasol"           | 41               | 2016            | 38               |
      | "男"                  | UNKNOWN_PROP            | "Hornets"              | 41               | 2018            | __NULL__         |
      | "男"                  | UNKNOWN_PROP            | "Hornets"              | 41               | 2018            | __NULL__         |
    When executing query:
      """
      match (src_v:player{name:"Manu Ginobili"})-[e:like*2..3]-(dst_v) return properties(src_v).sex,properties(e[0]).degree,properties(dst_v).name,src_v.player.age, e[1].start_year,dst_v.player.age limit 5;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(src_v).sex | properties(e[0]).degree | properties(dst_v).name | src_v.player.age | e[1].start_year | dst_v.player.age |
      | "男"                  | 88                      | "LaMarcus Aldridge"    | 41               | 2022            | 33               |
      | "男"                  | 88                      | "LaMarcus Aldridge"    | 41               | 2022            | 33               |
      | "男"                  | 88                      | "LaMarcus Aldridge"    | 41               | 2022            | 33               |
      | "男"                  | 88                      | "LaMarcus Aldridge"    | 41               | 2022            | 33               |
      | "男"                  | 88                      | "Manu Ginobili"        | 41               | 2022            | 41               |
    When executing query:
      """
      match (v1)-->(v2)-->(v3) where id(v1)=="Manu Ginobili"  return properties(v1).name,properties(v2).age,properties(v3).name limit 1;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(v1).name | properties(v2).age | properties(v3).name |
      | "Manu Ginobili"     | 36                 | "Hornets"           |
    When executing query:
      """
      match (v1)-->(v2)-->(v3) where id(v1)=="Manu Ginobili"  return properties(v1).name,properties(v2).age,properties(v3).name,v1.player.sex,v2.player.sex,id(v3) limit 1;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(v1).name | properties(v2).age | properties(v3).name | v1.player.sex | v2.player.sex | id(v3)    |
      | "Manu Ginobili"     | 36                 | "Hornets"           | "男"          | "男"          | "Hornets" |
    When executing query:
      """
      match (v1)-->(v2:player)-->(v3) where v2.player.name=="Shaquille O'Neal"  return properties(v1).name,properties(v2).age,properties(v3).name,v2.player.sex,v1.player.age limit 1;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(v1).name | properties(v2).age | properties(v3).name | v2.player.sex | v1.player.age |
      | "Yao Ming"          | 47                 | "Suns"              | "男"          | 38            |
    When executing query:
      """
      match (v1)-->(v2:player)-->(v3) where v2.player.name=="Shaquille O'Neal"  return properties(v1).name,properties(v2).age,properties(v3).name limit 1;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(v1).name | properties(v2).age | properties(v3).name |
      | "Yao Ming"          | 47                 | "Suns"              |
    When executing query:
      """
      match (v1)-->(v2)-->(v3:team{name:"Celtics"})   return properties(v1).name,properties(v2).age,properties(v3).name limit 1;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(v1).name | properties(v2).age | properties(v3).name |
      | "Rajon Rondo"       | 43                 | "Celtics"           |
    When executing query:
      """
      match (src_v)-[e:like|serve{degree:88}]->(dst_v) where  id(src_v)=="Rajon Rondo" return properties(e).degree,e.end_year limit 10;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(e).degree | e.end_year   |
      | 88                   | 2018         |
      | 88                   | 2015         |
      | 88                   | 2017         |
      | 88                   | 2016         |
      | 88                   | 2019         |
      | 88                   | UNKNOWN_PROP |
      | 88                   | 2014         |
    When executing query:
      """
      match (src_v)-[e:like|serve]->(dst_v)-[e2]-(dst_v2) where  id(src_v)=="Rajon Rondo" return properties(e).degree,properties(e2).degree limit 5;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(e).degree | properties(e2).degree |
      | 90                   | 88                    |
      | 88                   | 88                    |
      | 88                   | 88                    |
      | 95                   | 80                    |
      | 88                   | 88                    |

  Scenario: match wrong syntax
    When executing query:
      """
      match (src_v)-[e:like|serve]->(dst_v)-[e2]-(dst_v2) where  id(src_v)=="Rajon Rondo" return properties(e).degree1,properties(e).degree1,e2.a,dst_v.p.name,dst_v.player.sex1,properties(src_v).name2 limit 5;
      """
    Then the result should be, in any order, with relax comparison:
      | properties(e).degree1 | properties(e).degree1 | e2.a         | dst_v.p.name | dst_v.player.sex1 | properties(src_v).name2 |
      | UNKNOWN_PROP          | UNKNOWN_PROP          | UNKNOWN_PROP | __NULL__     | __NULL__          | UNKNOWN_PROP            |
      | UNKNOWN_PROP          | UNKNOWN_PROP          | UNKNOWN_PROP | __NULL__     | __NULL__          | UNKNOWN_PROP            |
      | UNKNOWN_PROP          | UNKNOWN_PROP          | UNKNOWN_PROP | __NULL__     | __NULL__          | UNKNOWN_PROP            |
      | UNKNOWN_PROP          | UNKNOWN_PROP          | UNKNOWN_PROP | __NULL__     | __NULL__          | UNKNOWN_PROP            |
      | UNKNOWN_PROP          | UNKNOWN_PROP          | UNKNOWN_PROP | __NULL__     | __NULL__          | UNKNOWN_PROP            |
    Then drop the used space
