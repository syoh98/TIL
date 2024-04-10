**✏️`StringBuffer`클래스와 `StringBuilder`클래스**  
* 둘의 차이는 무엇일까?
  * `StringBuffer`: 스레드에 안전하게 **(ThreadSafe)** 설계되어 있기 때문에, 여러 개의 스레드에서 하나의 StringBuffer 객체를 처리해도 문제없다.
  * `StringBuilder`: 단일 스레드에서의 안정성만 보장한다. 때문에 여러 개의 스레드에서 하나의 StringBuilder 객체를 처리하면 문제가 발생한다.
* 생성자
  * StringBuffer()
  * StringBuffer(CharSequence seq)
    * CharSequence는 인터페이스이다. 이 인터페이스를 구현한 클래스로는 `CharBuffer`, `String`, `StringBuffer`, `StringBuilder`가 있다. `StringBuffer`나 `StringBuilder`로 생성한 객체를 전달할 때 사용한다. 
  * StringBuffer(int capacity)
  * StringBuffer(String str)
* 메서드(많이 사용하는)
  * append(): 기존 값의 맨 끝 자리에 넘어온 값을 덧붙이는 작업을 수행
  * insert(): 지정된 위치 이후에 넘어온 값을 덧붙이는 작업을 수행
</br>

**✏️`String`vs `StringBuffer` vs `StringBuilder`**  
* `String` 클래스의 원리
  * a += aValue를 반복하는 경우   
    <img src="https://github.com/syoh98/TIL/assets/76934280/bc050c63-0a8c-42ad-948f-9d24c1e3ca42" width="400"/></br>

    첫 번째 수행: a += aValue ➡️ abcde   
    두 번째 수행: a += aValue ➡️ abcdeabcde ➡️ 첫 번째 수행 객체인 a가 쓰레기가 된다      
    세 번째 수행: a += aValue ➡️ abcdeabcdeabcde ➡️ 두 번째 수행 객체인 a가 쓰레기가 된다
    새로운 객체를 생성하고, 쓰레기가 되는 작업이 반복 수행되면서 메모리를 많이 사용하게 되고, 응답 속도에 많은 영향을 끼치게 된다.
    GC를 하면 할수록 시스템의 CPU를 많이 사용하게 되고 시간도 많이 소모된다
* `StringBuffer`와 `StringBuilder`의 원리   
  <img src="https://github.com/syoh98/TIL/assets/76934280/1ddcff16-dd62-4f2e-8000-8cc683590def" width="400"/></br>
  String과는 다르게 새로운 객체를 생성하지 않고, 기존에 있는 객체의 크기를 증가시키면서 값을 더한다.   
</br>

  **💡그럼 String을 쓰는 것은 무조건 나쁜 것일까?**   
  아니다! 경우에 따라 사용하자
  * String
    * 짧은 문자열을 더할 경우 사용
  * StringBuffer
    * 스레드에 안전한 프로그램이 필요할 때나, 개발 중인 시스템의 부분이 스레드에 안전한지 모를 경우 사용
    * 만약 클래스에 static으로 선언한 문자열을 변경하거나, singleton으로 선언된 클래스에 선언된 문자열일 경우 사용
  * StringBuilder
    * 스레드의안전한지의 여부와 관계 없는 프로그램을 개발할 때 사용
    * 만약 메서드 내에 변수를 선언했다면, 해당 변수는 그 메서드 내에서만 살아있으므로 해당 클래스 사용   
