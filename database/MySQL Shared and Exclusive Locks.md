## ✏️ 비관적락이란?
트랜잭션 충돌이 발생할 것이라고 비관적으로 가정하는 방법이다.   
실제 데이터에 Lock을 걸어서 데이터의 정합성을 맞춘다.  

## ✏️ MySQL의 비관적락 종류
* **shared lock**
  * 보유하는 트랜잭션이 행을 읽을 수 있도록 허용하는 락이다.
  * `SELECT ... FOR SHARE`문을 사용한다.
  * read한 모든 row에 shared mode lock을 설정한다. 다른 세션에서는 row를 읽을 수 있지만, 트랜잭션이 commit될 때까지 수정은 불가하다. commit되지 않은 다른 트랜잭션에 의해 해당하는 row가 변경된 경우 쿼리는 해당 트랜잭션이 끝날 때까지 기다린 다음 최신 값을 사용한다.
* **exclusive lock**
  * 락을 보유한 트랜잭션이 행을 업데이트하거나 삭제할 수 있다.
  * `SELECT ... FOR UPDATE`문을 사용한다.
  * 한 트랜잭션 내에 위의 명령어 수행 후, 다른 트랜잭션이 해당 row를 업데이트하거나 `SELECT ... FOR SHARE`를 수행하거나 특정 트랜잭션 격리 수준에서 데이터를 읽는 것이 차단된다.   

## ✏️ shared lock & exclusive lock test
* **CASE 1**
  * **락의 단위는 트랜잭션임을 알 수 있다.**
  ![image](https://github.com/user-attachments/assets/94e6399b-cbf8-4418-9c73-712ee5cad4c7)
* **CASE 2**
  * **🤔 락을 걸면 무조건 조회를 못할까?** 아니다. mysql은 `잠금없는 일관된 읽기`를 제공한다.
  ![image](https://github.com/user-attachments/assets/32322e22-c61f-4fb7-9a33-2d641de5c091)
* **CASE 3**
  * **🤔 그럼 잠금없는 일관된 읽기를 막을 방법도 있을까?** 있다. for shared를 사용하면 잠금없는 읽관된 읽기를 막는다.
  ![image](https://github.com/user-attachments/assets/ecc73cb3-d5af-4881-9df0-197bbe12d9a3)
* **CASE 4**
  * **🤔 `for update`말고 `for shared`만 사용하면 어떻게 될까?** 커밋하지 않아도 모두 조회가 가능하다.
  ![image](https://github.com/user-attachments/assets/150b5b4a-04ef-4ff8-9d9a-c0b7d43c4d61)
* **CASE 5**
  * **🤔 락 때문에 부하를 많이 가지는 않을까?** 이럴 때 유용하게 사용하는 **skip locked**
  * **`skip locked`**: 행 잠금을 획득할 때까지 기다리지 않는다. 쿼리가 즉시 실행되어 result set에서 잠긴 행이 제거된다.
  ![image](https://github.com/user-attachments/assets/e0068eea-85a5-4b61-89ea-eac8b266eac0)   
  ➡️ 락을 계속해서 기다리게 하는 행위는 부하를 많이 준다. 커넥션을 계속 점유해야 하는데, 데이터베이스와 서버와의 커넥션 개수는 한계가 있다.   
  ➡️ 따라서 커넥션이 마르는 문제와 락 타임아웃 등의 문제가 발생하여 이를 방지하기 위해 `skip locked`를 사용한다.

## ✏️ 정리
* 비관적락(shared lock, exclusive lock)을 사용하여 `예약`같은 행위를 구현할 경우, exclusive lock을 획득하도록 하면 된다. 그러면 해당 트랜잭션을 커밋하기 전까지는 락이 유지가 되는 것이기 때문이다.
* FOR SHARE 또는 FOR UPDATE 수행 후 commit 또는 rollback을 수행하기 전 즉, 트랜잭션이 끝나기 전까지가 락의 구역이다.
* 비관적 락의 장점과 단점
  * 장점: 데이터의 일관성을 보장한다.
  * 단점: 성능 저하와 데드락의 발생 가능성이 높다.
* 위에서 진행한 테스트를 바탕으로 해당 표를 도출할 수 있다.
  ![image](https://github.com/user-attachments/assets/4720da93-acd2-421e-b691-0b1e733c476d)

</br></br></br>

* 참고
  * https://dev.mysql.com/doc/refman/8.0/en/innodb-locking-reads.html
  * https://dev.mysql.com/doc/refman/8.4/en/innodb-locking.html
