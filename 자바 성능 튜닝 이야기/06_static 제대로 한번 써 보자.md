**✏️static의 특징**   
자바에서 static으로 지정했다면, 해당 메서드나 변수는 정적이다.
* 자바 static에 대한 개념을 리마인드 해보면,,
  * static 초기화 블록
    * static 초기화 블록은 클래스 어느 곳에나 지정할 수 있다.
    * 클래스가 최초 로딩될 때 수행되므로 생성자 실행과 상관없이 수행된다.
    * 여러번 사용이 가능하다(이렇게 사용하면 가장 마지막에 지정된 값이 반영된다.)   
      즉, static블록은 순차적으로 읽혀진다.
  * static 특징
    * 다른 JVM에서는 static이라고 선언해도 다른 주소나 다른 값을 참조하지만, 하나의 JVM이나 WAS 인스턴스에서는 같은 주소에 존재하는 값을 참조한다. 또한 GC의 대상도 되지 않는다.   
      ➡️ 따라서 static을 잘 사용하면 성능을 뛰어나게 향상시킬 수 있지만, 잘못 사용하면 예기치 못한 결과를 초래한다(ex. 여러 쓰레드에서 하나의 변수의 접근하는 경우)
</br>

**✏️static 잘 활용하기**
* 자주 사용하고 절대 변하지 않는 변수는 final static으로 선언하자
  * 자주 사용되는 로그인 관련 쿼리들이나 간단한 목록 조회 쿼리를 final static으로 선언하면 적어도 1byte 이상의 객체가 GC 대상에 포함되지 않는다
  * 템플릿 성격의 객체를 static으로 선언하는 것도 성능 향상의 많은 도움이 된다
    ex) Velocity   
    Velocity란 자바 기반의 프로젝트를 수행할 때, UI가 될 수 있는 HTML뿐만 아니라, XML, 텍스트 등의 템플릿을 정해 놓고, 실행 시 매개변수 값을 던져서 원하는 형식의 화면을 동적으로 구성할 수 있도록 도와주는 컴포넌트
    하지만 template 내용이 지속적으로 변경되는 부분의 경우도 있을 수 있으니, 상황에 맞게 판단하여 static을 사용하자.
* 설정 파일 정보도 static으로 관리하자
  * 클래스의 객체를 생성할 때마다 설정 파일을 로딩하면 엄청난 성능 저하가 발생하게 된다.
* 코드성 데이터는 DB에서 한 번만 읽자
  * 큰 회사의 부서 코드처럼 양이 많고 자주 바뀔 확률이 높은 데이터를 제외하고, 부서가 적은 회사의 코드나, 건수가 그리 많지 않되 조회 빈도가 높은 코드성 데이터는 DB에서 한 번만 읽어서 관리하는 것이 성능 측면에서 좋다.
</br>

**✏️static 잘못 쓰면 이렇게 된다**
```java
public class BadQueryManager {
  private static String queryURL = null;
  public badQueryManager(String badUrl) {
    queryURL = badUrl;
  }
  public static String getSql(String idSql) {
    try {
      FileReader reader = new FileReader();
      HashMap<String, String> document = reader.read(queryURL);
      return document.get(idSql)
    } catch(Exception ex) {
      System.out.println(ex);
    }
    return null;
  }
}
```
* 만약 어떤 화면에서 BadQueryManager의 생성자를 통해서 queryURL을 설정하고 `getSql()` 메서드를 호출하기 전에, 다른 queryURL을 사용하는 화면의 스레드에서 BadQueryManager의 생성자를 호출하면 어떤 일이 발생할까?   
  ➡️ 이 경우 시스템이 오류를 발생시킨다   
  ➡️ 먼저 호출한 화면에서는 생성자를 호출했을 때의 URL을 유지하고 있을 것이라 생각하고 `getSql()` 메서드를 호출하겠지만, 이미 그 값은 변경되고 난 후다.
* 웹 환경이기 때문에 여러 화면에서 호출할 경우에 queryURL은 그때 그때 바뀌게 된다   
  * 다시 말하면, queryURL은 static으로 선언했기 때문에 클랫의 변수이지 객체의 변수가 아니다.
  * 모든 스레드에서 동일한 주소를 가리키게 되어 문제가 발생한 것이다.
</br>

**✏️static과 메모리 릭**   
static으로 선언한 부분은 GC가 되지 않는다.   
그럼 만약 어떤 클래스에 데이터를 Vector나 ArrayList에 담을 때 해당 Collection 객체를 static으로 선언하면 어떻게 될까?   
지속적으로 해당 객체에 데이터가 쌓인다면, 더 이상 GC가 되지 않으면서 시스템은 `OutOfMemoryError`를 발생시킨다.   
즉, 시스템을 재시작해야하며, 해당 인스턴스는 더 이상 서비스 할 수 없다.   
   
💡 메모리릭: **더 이상 사용 가능한 메모리가 없어지는 현상.** static과 Collection 객체를 잘못 사용하면 메모리 릭이 발생한다.     
</br>
📌 정리
static은 반드시 메모리에 올라가며 GC의 대상이 되지 않는다.   
객체를 다시 생성한다고 해도 그 값은 초기화되지 않고 해당 클래스를 사용하는 모든 객체에서 공유하게 된다.   
만약 static을 사용하는 것이 걱정된다면 쓰지말자.   
모르고 시스템이 잘못되는 것보다 아예 안 쓰는 것이 더 안전하다.
