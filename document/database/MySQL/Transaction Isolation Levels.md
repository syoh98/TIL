https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-isolation-levels.html   
   
* 트랜잭션 격리(transaction)는 데이터베이스 처리의 기초 중 하나이다. 격리는 약어 `ACID`의 `I`이다. 격리 수준은 여러 트랜잭션이 동시에 변경하고 쿼리를 수행할 때 성능과 안정성, 일관성, 결과 재현성 사이의 균형을 미세하게 조정하는 설정이다.   
* InnoDB는 **SQL:1992 표준**에 설명된 네 가지 트랜잭션 격리 수준(READ UNCOMMITTED, READ COMMITTED, REPEATABLE READ 및 SERIALIZABLE)을 제공한다. InnoDB의 기본 격리 수준은 REPEATABLE READ이다.   
* 사용자는 SET TRANSACTION 문을 사용하여 단일 세션 또는 모든 후속 연결에 대한 격리 수준을 변경할 수 있다. 모든 연결에 대해 서버의 기본 격리 수준을 설정하려면 명령줄이나 옵션 파일에서 --transaction-isolation 옵션을 사용하면 된다.   
* InnoDB는 다양한 lock 전략을 사용하여 여기에 설명된 각 트랜잭션 격리 수준을 지원한다. ACID 준수가 중요한 데이터 작업의 경우 기본 REPEATABLE READ 수준을 사용하여 높은 수준의 일관성을 적용할 수 있다. 또는 정확한 일관성과 반복 가능한 결과가 lock에 대한 오버헤드 양을 최소화하는 것보다 덜 중요한 대량 보고와 같은 상황에서는 READ COMMITTED 또는 READ UNCOMMITTED를 사용하여 일관성 규칙을 완화할 수 있다.   
* SERIALIZABLE은 REPEATABLE READ보다 훨씬 더 엄격한 규칙을 적용하며 XA 트랜잭션 및 동시성 및 데드락 문제 해결과 같은 특수한 상황에서 주로 사용된다.   

## 🔷 READ UNCOMMITTED
SELECT 문은 잠금 해제 방식으로 수행되지만 가능한 이전 버전의 행이 사용될 수도 있다.
따라서 이 격리 수준을 사용하면 읽기는 일관성이 없다. 이를 `dirty read`라고도 한다. 그렇지 않으면 이 격리 수준은 READ COMMITTED처럼 작동한다.   
</br>

## 🔷 READ COMMITTED
동일한 트랜잭션 내에서도 각각의 일관된 읽기는 자체적인 새로운 스냅샷을 설정하고 읽는다.   
잠금 읽기(`FOR UPDATE` 또는 `FOR SHARE`를 사용하는 SELECT), UPDATE 및 DELETE 문에서 InnoDB는 인덱스 레코드만 잠그고 그 이전의 gap은 잠그지 않으므로 잠긴 레코드 옆에 새 레코드를 자유롭게 삽입할 수 있다. gap locking은 외래 키 제약 조건 검사와 중복 키 검사에만 사용된다.   
READ COMMITTED 격리 수준에서는 row 기반 바이너리 로깅만 지원된다. `binlog_format=MIXED`와 함께 READ COMMITTED를 사용하면 서버는 자동으로 row 기반 로깅을 사용한다.   
READ COMMITTED를 사용하면 다음과 같은 추가적인 effects가 존재한다.   
* UPDATE 또는 DELETE 문의 경우 InnoDB는 업데이트하거나 삭제하는 행에 대해서만 lock을 보유한다. 일치하지 않는 row에 대한 레코드 잠금은 MySQL이 WHERE 조건을 평가한 후에 해제된다.   
  이런 경우 데드락의 가능성이 크게 줄어들지만 데드락의 발생가능성은 여전히 존재한다.   
* UPDATE 문의 경우 row가 이미 잠겨 있으면 InnoDB는 "semi-consistent" 읽기를 수행하여 row가 UPDATE의 WHERE 조건과 일치하는지 여부를 결정할 수 있도록 최신 커밋된 버전을 MySQL에 반환한다. row가 일치하면(업데이트해야 함) MySQL은 row를 다시 읽고 이번에는 InnoDB가 해당 row를 잠그거나 lock을 기다린다.   

다음과 같이 생성된 테이블을 생각해보자 
```MySQL
CREATE TABLE t (a INT NOT NULL, b INT) ENGINE = InnoDB;
INSERT INTO t VALUES (1,2),(2,3),(3,2),(4,3),(5,2);
COMMIT;
```
이 경우 테이블에는 인덱스가 없으므로 검색 및 인덱스 스캔에서는 레코드 잠금을 위해 hidden clustered 인덱스를 사용한다.

한 세션이 다음 명령문을 사용하여 업데이트를 수행하고
```MySQL
# Session A
START TRANSACTION;
UPDATE t SET b = 5 WHERE b = 3;
```
두 번째 세션이 첫 번째 세션의 명령문 다음에 명령문을 실행하여 업데이트를 수행한다고 가정해보자.
```MySQL
# Session B
UPDATE t SET b = 4 WHERE b = 2;
```
InnoDB는 각 UPDATE를 실행할 때 먼저 각 row에 대해 배타 lock을 획득한 다음 이를 수정할지의 여부를 결정한다. InnoDB가 row를 수정하지 않으면 lock을 해제한다. 그렇지 않으면 InnoDB는 트랜잭션이 끝날 때까지 lock을 유지한다. 이는 다음과 같은 트랜잭션 처리에 영향을 미친다.   
기본 REPEATABLE READ 격리 수준을 사용하는 경우 첫 번째 UPDATE는 읽는 각 행에 대해 x 잠금을 획득하고 그 중 어떤 것도 해제하지 않는다.
```MySQL
x-lock(1,2); retain x-lock
x-lock(2,3); update(2,3) to (2,5); retain x-lock
x-lock(3,2); retain x-lock
x-lock(4,3); update(4,3) to (4,5); retain x-lock
x-lock(5,2); retain x-lock
```
두 번째 UPDATE는 잠금을 획득하려고 시도하는 즉시 차단되며(첫 번째 업데이트가 모든 row에 대한 잠금을 유지했기 때문에) 첫 번째 UPDATE가 커밋되거나 롤백될 때까지 진행되지 않는다.
```MySQL
x-lock(1,2); block and wait for first UPDATE to commit or roll back
```
대신 READ COMMITTED를 사용하면 첫 번째 UPDATE는 읽는 각 row에 대해 x-lock을 획득하고 수정하지 않는 row에 대해 lock을 해제한다.
```MySQL
x-lock(1,2); unlock(1,2)
x-lock(2,3); update(2,3) to (2,5); retain x-lock
x-lock(3,2); unlock(3,2)
x-lock(4,3); update(4,3) to (4,5); retain x-lock
x-lock(5,2); unlock(5,2)
```
두 번째 UPDATE의 경우 InnoDB는 "semi-consistent" 읽기를 수행하여 읽은 각 row의 최신 커밋된 버전을 MySQL에 반환하므로 MySQL은 해당 행이 UPDATE의 WHERE 조건과 일치하는지 여부를 확인할 수 있다.
```MySQL
x-lock(1,2); update(1,2) to (1,4); retain x-lock
x-lock(2,3); unlock(2,3)
x-lock(3,2); update(3,2) to (3,4); retain x-lock
x-lock(4,3); unlock(4,3)
x-lock(5,2); update(5,2) to (5,4); retain x-lock
```
그러나 WHERE 조건에 인덱싱된 열이 포함되고 InnoDB가 해당 인덱스를 사용하는 경우 레코드 lock을 걸고 유지할 때 인덱싱된 열만 고려된다.   
다음 예에서 첫 번째 UPDATE는 b = 2인 각 행에서 x-lock을 가져와 유지한다.두 번째 UPDATE는 동일한 레코드에서 x-lock을 얻으려고 시도할 때 b열에 정의된 인덱스도 사용하므로 차단된다.
```MySQL
CREATE TABLE t (a INT NOT NULL, b INT, c INT, INDEX (b)) ENGINE = InnoDB;
INSERT INTO t VALUES (1,2,3),(2,2,4);
COMMIT;

# Session A
START TRANSACTION;
UPDATE t SET b = 3 WHERE b = 2 AND c = 3;

# Session B
UPDATE t SET b = 4 WHERE b = 2 AND c = 4;
```
READ COMMITTED 격리 수준은 시작 시 설정되거나 런타임 시 변경될 수 있다. 런타임 시 모든 세션에 대해 전체적으로 설정하거나 세션별로 개별적으로 설정할 수 있다.   
</br>

## 🔷 REPEATABLE READ
InnoDB의 default 격리 수준이다.   
동일한 트랜잭션 내 일관된 읽기는 첫 번째 읽기로 설정된 스냅샷을 읽는다. 이는 동일한 트랜잭션 내에서 여러 일반(잠금 해제)SELECT 문을 실행하는 경우 SELECT 문은 서로에 대해서도 일관성이 있음을 의미한다.   
잠금 읽기(`FOR UPDATE` 또는 `FOR SHARE`를 사용하는 SELECT), UPDATE 및 DELETE 문에서 락은 해당 명령문에 검색 조건이 있는 unique 인덱스를 사용하는지 아니면 범위 유형 검색 조건을 사용하는지에 따라 달라진다.   
unique 검색 조건이 있는 경우 unique 인덱스의 경우 InnoDB는 발된 인덱스 레코드만 lock하고 이전 gap은 lock하지 않는다.   
다른 검색 조건의 경우 InnoDB는 `gap lock` 또는 `next-key lock`을 사용하여 스캔된 인덱스 범위를 lock하고 다른 세션이 삽입되는 것을 차단한다.   
</br>

## 🔷 SERIALIZABLE
이 수준은 REPEATABLE READ와 비슷하지만 자동 커밋이 비활성화된 경우 InnoDB는 모든 일반 SELECT문을 `SELECT … FOR SHARE`로 임시로 변환한다. 자동 커밋이 활성화된 경우 SELECT는 자체 트랜잭션이다.    
따라서 읽기 전용으로 알려져 있으며 일관된(nonlocking) 읽기로 수행되는 경우 직렬화 될 수 있으며 다른 트랜잭션에 대해 차단할 필요가 없다.   
다른 트랜잭션이 선택한 row를 수정한 경우 일반 SELECT를 강제로 차단하려면 자동 커밋을 비활성화해야한다.   
(조인 목록 또는 하위 쿼리를 통해) MySQL 그랜트 테이블에서 데이터를 읽지만 수정하지 않는 DML 작업은 격리 수준에 관계없이 MySQL 그랜트 테이블에 대한 읽기 잠금을 획득하지 않는다.
