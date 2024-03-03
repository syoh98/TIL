## ✏️ 쓰레드
프로세스란? 실행 중인 프로그램<br>
쓰레드란? 프로세스의 자원을 이용해서 실제로 작업을 수행하는 것

* 📝 구현방법
  * Thread클래스를 상속
    ```java
    class MyThread extends Thread {
       public void run() { /* 작업내용 */} // Thread클래스의 run()을 오버라이딩
    }
    ```
  * Runnable인터페이스를 구현
    ```java
    class MyThread implements Runnable {
       public void run() { /* 작업내용 */} // Runnable인터페이스의 run()을 구현
    }
    ```
    Thread클래스를 상속받으면 다른 클래스를 상속받을 수 없기 때문에(다중상속 불가), Runnable 인터페이스를 구현하는 방법이 일반적<br>
    쓰레드를 구현한다는 것은, 두가지 방법 모두 쓰레드를 통해 작업하고자 하는 내용으로 <b>run()의 몸통을 만들어주는 것</b>이다<br>
  * 실행
    * 쓰레드를 생성했다고해서 자동 실행 X, <b>start()</b>를 호출해야 실행
  * 주의점
     * 한 번 실행이 종료된 쓰레드는 다시 실행할 수 없음. 하나의 쓰레드에 대해 start() 한 번 호출 가능
     * 실행 중인 사용자 쓰레드가 하나도 없을 때 프로그램은 종료
     * 하나의 쓰레드에 대해 start() 두 번 이상 호출 시 IllegalThreadStartExceprion 발생
   
* 📝 종류
  * 사용자 쓰레드
  * 데몬 쓰레드: 일반쓰레드의 작업을 돕는 보조적인 역할을 수행하는 쓰레드
    * 예시: 가비지 컬렉터, 화면자동갱신
    * 사용법
      무한루프와 조건문을 이용해서 실행 후 대기하다가 특정 조건이 만족되면 작업을 수행하고 다시 대기하도록 작성
      쓰레드 생성 후 실행 전 setDaemon(true) 호출
      ```java
      // 쓰레드가 데몬쓰레드인지 확인한다
      // 데몬쓰레드이면 true를 반환한다
      boolean isDaemon() 

      // 쓰레드를 데몬 쓰레드로 또는 사용자 쓰레드로 변경한다
      // 매개변수 on의 값을 true로 지정하면 데몬 쓰레드가 된다
      void setDaemon(boolean on)
      ```
<hr>

* 💥 쓰레드 상태<br>
  * NEW
  * RUNNABLE
  * BLOCKED
  * WAITING, TIMED_WAITING
  * TERMINATED

* 💥 메서드
  * sleep(long millis): 현재 실행 중인 쓰레드를 일정시간동안 정지
  * suspend(): 쓰레드를 정지
  * resume(): suspend()로 정지된 쓰레드를 실행대기 상태로 변경
  * stop(): 호출되는 즉시 쓰레드 종료
  * join(): 쓰레드 자신이 하던 작업을 잠시 멈추고 다른 쓰레드의 작업을 기다림
  * yield(): 쓰레드 자신에게 주어진 실행시간을 다음 차례의 쓰레드에게 양보
  * interrupt(): 쓰레드의 작업을 취소
      ```java
      // 쓰레드의 interrupted 상태를 false에서 true로 변경
      void interrupt()

      // 쓰레드의 interrupted상태를 반환
      boolean isInterrupted()

      // 현재 쓰레드의 interrupted상태를 반환 후, false로 변경
      static boolean interrupted()
      ```
    suspend(), resume(), stop()->deprecated(교착상태를 일으킴)
    
* 💥 동기화
  * synchronized 동기화
    * lock의 획득과 반납이 자동적으로 이루어진다
    * 메서드 전체를 임계영역으로 지정하는 방법과 특정 영역을 임계영역으로 지정하는 방법이 있음
      ```java
      // 1. 메서드 전체를 임계영역으로 지정
      public synchronized void calcSum() { // ... }

      // 2. 특정한 영역을 임계 영역으로 지정
      synchronized(객체의 참조변수) { // ... }
      ```
  * wait()과 notify()
    * synchronized방법의 특정 쓰레드가 락을 가진 상태로 오랜시간을 보내는 단점을 고안해낸 방법
    * wait(): 쓰레드가 락을 반납하고 기다림
    * notify(): 작업을 진행할 수 있는 상황이 되었을 때 호출하여, 작업을 중단했던 쓰레드가 다시 락을 얻어 작업을 진행할 수 있게 됨
  * Lock과 Condition을 이용한 동기화
    * ‘java.util.concurrent.locks’패키지가 제공
    * synchronized 동기화는 같은 메서드 내에서만 lock을 걸 수 있다는 제약이 불편할 때 사용한다.
    * ReentrantLock
    * ReentrantReadWriteLock
    * StampedLock
