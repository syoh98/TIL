## *️⃣MVCC(Multi Version Concurrency Control)란?
하나의 레코드에 대해 여러 개의 버전을 동시에 관리하는 기술이다.   
**MVCC의 가장 큰 목적은 잠금을 사용하지않는 일관된 읽기를 제공하는 데 있다.**   
</br>

### ✏️ 예시를 통해 MVCC가 무엇인지 확인해보자
```sql
CREATE TABLE member (
    m_id INT NOT NULL,
    m_name VARCHAR(20) NOT NULL,
    m_area VARCHAR(100) NOT NULL,
    PRIMARY KEY (m_id),
    INDEX ix_area (m_area)
);

INSERT INTO member (m_id, m_name, m_area) VALUES (12, '홍길동', '서울');
COMMIT;
```
<img src="https://github.com/user-attachments/assets/59869530-83fa-4062-bbbf-1a9195d18027" width="400"/></br>
➡️ 위 명령어를 수행했을 때, INSERT 문이 실행되면 데이터베이스의 상태는 이와 같다.

<img src="https://github.com/user-attachments/assets/57a8b799-cc28-42c9-82cd-fb136ef2ab73" width="400"/></br>
➡️ `UPDATE member SET m_area=’경기’ WHERE m_id=12;` 문장이 실행되면 커밋 실행 여부와 관계없이 InnoDB의 버퍼 풀은 새로운 값인 ‘경기’로 업데이트 된다.   
🤔 그럼, 아직 COMMIT 또는 ROLLBACK이 되지 않은 상태에서 다른 사용자가 `SELECT * FROM WHERE m_id=12;` 로 작업 중인 레코드를 조회하면 어디에 있는 데이터를 조회할까?   
**이 질문의 답은 MySQL 서버의 시스템 변수에 설정된 격리 수준에 따라 다르다는 것이다.**   
* 격리 수준이 **READ_UNCOMMITTED**인 경우, InnoDB 버퍼 풀은 현재 가지고 있는 변경된 데이터를 읽어서 반환한다.   
* 격리 수준이 **READ_COMMITED, REPEATABLE_READ, SERIALIZABLE** 인 경우에는 아직 커밋되지 않았기 때문에 InnoDB 버퍼 풀이나 데이터 파일에 있는 내용 대신 변경되기 이전의 내용을 보관하고 있는 언두 영역의 데이터를 반환한다.   
**이러한 과정을 DBMS에서는 `MVCC`라고 표현한다.**   
즉, 하나의 레코드(회원 번호가 12인 레코드)에 대해 2개의 버전이 유지되고, 필요에 따라 어느 데이터가 보여지는지 여러 가지 상황에 따라 달라지는 구조다.   
</br>

## *️⃣그럼 MVCC의 가장 큰 목적이라는 잠금 없는 일관된 읽기는 무엇일까?
InnoDB 스토리지 엔진은 MVCC 기술을 이용해 **잠금을 걸지 않고 읽기 작업을 수행**한다.   
**잠금을 걸지 않기 때문에 InnoDB에서 읽기 작업은 다른 트랜잭션이 가지고 있는 잠금을 기다리지 않고, 읽기 작업이 가능하다.**   
격리 수준이 SERIALIZABLE이 아닌 경우(**READ_COMMITED, REPEATABLE_READ, SERIALIZABLE**) INSERT와 연결되지 않은 순수한 읽기(SELECT) 작업은 다른 트랜잭션의 변경 작업과 관계없이 항상 잠금을 대기하지 않고 바로 실행된다.

### ✏️ 예시를 확인해보자
<img src="https://github.com/user-attachments/assets/24438688-6811-4624-bcc1-606df801812e" width="400"/></br>
특정 사용자가 레코드를 변경하고 아직 커밋을 수행하지 않았다고 하더라도 해당 변경 트랜잭션이 다른 사용자의 SELECT 작업을 방해하지 않는다.
**이를 잠금 없는 일관된 읽기라고 표현하며,** InnoDB에서는 변경되기 전의 데이터를 읽기 위해 언두 로그를 사용한다. 
