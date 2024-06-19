https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-controller/ann-exceptionhandler.html

## Exceptions
`@Controller` 및 `@ControllerAdvice` 클래스는 다음 예제와 같이 컨트롤러 메서드의 예외를 처리하기 위해 `@ExceptionHandler` 메서드를 가질 수 있습니다.
```java
@Controller
public class SimpleController {

	// ...

	@ExceptionHandler
	public ResponseEntity<String> handle(IOException ex) {
		// ...
	}
}
```
* 예외는 전파되는 최상위 예외(예: 직접 `IOException` 발생) 또는 wrapper 예외 내의 중첩 원인(예: `IllegalStateException` 내에 래핑된 `IOException`)과 일치할 수 있습니다.   
  5.3부터는 임의의 원인 수준에서 일치할 수 있지만 이전에는 즉각적인 원인만 고려되었습니다.
* 일치하는 예외 유형의 경우 앞의 예제와 같이 **대상 예외를 메서드 인수로 선언하는 것이 좋습니다.**
* 여러 예외 메서드가 일치하는 경우 일반적으로 원인 예외 일치보다 루트 예외 일치가 선호됩니다.   
  보다 구체적으로 `ExceptionDepthComparator`는 발생한 예외 유형의 깊이를 기준으로 예외를 정렬하는 데 사용됩니다.
* **또는 다음 예제와 같이 어노테이션 선언을 통해 일치하도록 예외 유형을 좁힐 수 있습니다.**
  ```java
  @ExceptionHandler({FileSystemException.class, RemoteException.class})
  public ResponseEntity<String> handle(IOException ex) {
	  // ...
  }
  ```
* 다음 예제와 같이 매우 일반적인 argument와 함께 특정 예외 유형 목록을 사용할 수도 있습니다.
  ```java
  @ExceptionHandler({FileSystemException.class, RemoteException.class})
  public ResponseEntity<String> handle(Exception ex) {
	  // ...
  }
  ```
