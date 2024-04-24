## 🗯️ Annotation을 이용한 Spring의 Exception 예외처리
Spring에는 **@ExceptionHandler**와 **@ControllerAdvice**로 예외를 처리할 수 있다.

## 1️⃣ @ExceptionHandler
* **Controller 내**의 Method 범위로 Exception을 처리한다. (Target - Method)
* ExceptionHandler의 속성으로 전달한 Exception이 발생하면, `@ExceptionHandler`가 붙은 메서드가 이를 catch하여 실행하는 방식으로 동작한다.
* `@ExceptionHandler`의 속성 값으로 넘겨준 Exception 객체는 하위 객체일수록 높은 우선순위를 갖는다.   
  ex)
  ```java
  @ExceptionHandler(Exception.class)
  public void doWhenExceptionThrown() {
      System.out.println("doWhenExceptionThrown executed!!");
  }

  @ExceptionHandler(ArithmeticException.class)
  public void doWhenArithmeticExceptionThrown() {
        System.out.println("doWhenArithmeticExceptionThrown executed!!");
  }
  ```
  → ArithmeticException은 Exception을 상속받았기 때문에 ArithmeticException이 발생할 경우, doWhenArithmeticExceptionThrown()이 실행된다. (하위 객체가 높은 우선순위를 갖기 때문이다)
* `@ExceptionHandler`의 적용범위
  * 기본적으로 `@Controller` 어노테이션이 붙은 범위 내에서 적용이 가능하다.   
    ➡️ 그러나, 모든 컨트롤러마다 동일한 `@ExceptionHandler`를 구현하는 것은 코드의 중복을 발생시켜 유지보수를 어렵게 한다.   
    💡 이러한 단점을 보완하기 위해 발생하는 예외들을 한 곳에서 관리하고 처리할 수 있는 `@ControllerAdvice`(`@RestControllerAdvice`)와 함께 사용한다.

## 2️⃣ @ControllerAdvice(GlobalExceptionHandler)
* Controller 전역에 걸쳐 Exception을 처리한다. (Target - TYPE(=Class, Interface, Enum))
* 이와 같은 코드를 작성하면, 어플리케이션 내의 모든 컨트롤러에서 발생하는 IllegalArgumentException 을 해당 메서드가 처리하게 된다.
  ```java
  @ControllerAdvice
  public class SimpleControllerAdvice {

      @ExceptionHandler(IllegalArgumentException.class)
      public ResponseEntity<String> IllegalArgumentException() {
          return ResponseEntity.badRequest().build();
      }
  }
  ```
* 설정을 통해 범위 지정이 가능하며, Default 값으로 모든 Controller에 대해 예외 처리를 관리한다.(ex) @RestControllerAdvice(basePackages=”flab.gotable.controller”))

## 🤔 @ExceptionHandler와 @ControllerAdvice의 차이
두 어노테이션의 차이는 Exception의 적용범위이다.
* @ExceptionHandler는 해당 코드를 작성한 Controller 내에서만 적용된다. (= 다른 Controller에서 발생한 예외는 처리하지 않는다.)
* @ControllerAdvice는 모든 Controller의 예외를 처리한다.

## 🤔 @ControllerAdvice의 동작원리(DispatcherServlet)
* **예외처리 동작과정**   
  <img src="https://github.com/syoh98/TIL/assets/76934280/bed31951-522e-4fef-bd85-804885ca6dfa" width="600"/></br>
* **동작과정을 코드로 확인했을 때**
  * `doDispatch()`   
    ![image](https://github.com/syoh98/TIL/assets/76934280/1dc640bd-e266-47a3-8fae-db4cf7bdbb33)
    * 먼저 `DispatherServlet.class`→`doDispatch()`에서 예외처리를 시작한다.
    * 처리할 handler가 존재하지 않으면 `noHandlerFound()`로 페이지를 찾지 못했다는 응답을 처리한다.
    * 처리할 handler가 존재하는 경우 중간에 예외가 발생하면 `processDispatchResult()`로 예외 인자를 넘겨 예외를 처리한다.
  * `processDispatchResult()`   
    ![image](https://github.com/syoh98/TIL/assets/76934280/bfb15f99-197a-487b-8d69-7da7d8e00b79)
    * 전달받은 예외 인자 중 (`exception != null`)이면(= exception이 발생했으면) `processHandlerException()`을 호출한다.
  * `processHandlerException()`
    ![image](https://github.com/syoh98/TIL/assets/76934280/647b4f57-8331-47d5-bded-03595ddd79ba)
    * 저장된 `HandlerExceptionResolver`를 모두 탐색해서 4개의 인자에 맞는 `resolveException()`을 처리해 결과를 얻어오고, 결과를 처리할 수 있다면 더 이상 순회하지 않는다.
    * `handlerExceptionResolvers`는 `@ControllerAdvice`로 정의된 빈이 주입된다.
</br>

* 참고
  * https://dev.gmarket.com/83
  * https://tecoble.techcourse.co.kr/post/2023-05-03-ExceptionHandler-ControllerAdvice/
  * https://velog.io/@e1psycongr00/Spring-예외-처리-동작-원리
