![image](https://github.com/syoh98/TIL/assets/76934280/100791e1-c27e-493d-9b85-57ddd2af6cf2)
## 1️⃣ Filter
Filter는 리소스(servlet 또는 정적 컨텐츠)에 대한 요청이나 응답에 포함된 정보를 변환하는 기능을 제공한다.
* **실행시점**   
  Dispatcher Servlet에 요청이 전달되기 전, 후이다.
* **메서드**   
  ![image](https://github.com/syoh98/TIL/assets/76934280/75d2f506-527f-4bc2-9461-2253a9fdba0f)   
  ➡️ 각 메서드 상세 설명: https://github.com/syoh98/TIL/blob/master/spring%20Study/Servlet%20Filter%2C%20Spring%20Interceptor.md
</br>

## 2️⃣ Interceptor
Interceptor는 요청과 응답을 참조하거나 가공할 수 있는 기능을 제공한다.
* **실행시점**   
  Dispather Servlet이 Controller를 호출하기 전, 후이다.
* **메서드**   
  ![image](https://github.com/syoh98/TIL/assets/76934280/b5f89fa0-91f1-460b-8c68-de9bcb4157ff)
  ➡️ 각 메서드 상세 설명: https://github.com/syoh98/TIL/blob/master/spring%20Study/Servlet%20Filter%2C%20Spring%20Interceptor.md
* **주의할 점**([🍃Spring 공식문서](https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-config/interceptors.html#page-title))
  ```
  Note: Interceptors are not ideally suited as a security layer due to the potential for a mismatch with annotated controller path matching.
  Generally, we recommend using Spring Security, or alternatively a similar approach integrated with the Servlet filter chain, and applied as early as possible.
  ```
  `인터셉터`는 annotation이 달린 Controller 경로와의 불일치 가능성으로 인해 **보안적인 면에서 이상적으로 적합하지 않다.**   
   따라서 Spring Security를 사용하거나 Servlet Filter Chain과 통합하는 방식을 권장한다.
</br>

## 💡 Filter와 Interceptor의 차이
* **Spring에서 설명하고 있는([🍃Spring 공식문서](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/servlet/HandlerInterceptor.html)) 필터와 인터셉터의 차이점**   
  ```
  As a basic guideline, fine-grained handler-related preprocessing tasks are candidates for HandlerInterceptor implementations,
  especially factored-out common handler code and authorization checks.
  On the other hand, a Filter is well-suited for request content and view content handling, like multipart forms and GZIP compression.
  This typically shows when one needs to map the filter to certain content types (e.g. images), or to all requests.
  ```
  기본 가이드 라인으로 `인터셉터`는 **핸들러의 반복 코드 제거** 및 **권한 확인 시 사용**하는 것을 권장하고, `필터`는 multipart form, GZIP 압축과 같은 요청 컨텐츠 및 보기 컨텐츠 처리에 적합하다.
* `필터`는 J2EE 표준 스펙으로 **스프링 범위 밖에서 동작**한다.   
  인터셉터는 Spring이 제공하는 기술로 **스프링 범위 내(스프링 컨텍스트)에서 동작**한다.
  * 따라서, 필터는 스프링이 처리해주는 `@ControllerAdvice`를 사용할 수 없다.
</br>

## 3️⃣ AOP
애플리케이션의 핵심적인 기능에서 부가적인 기능을 분리해서 Aspect 모듈로 만들어 설계하고 개발하는 방법으로 코드의 중복을 줄이기 위해 사용한다.
* `주소`, `파라미터`, `어노테이션`의 방법으로 대상을 지정할 수 있다.
* 로깅, 트랜잭션, 에러처리 등 비즈니스 단의 **메서드에서** 더욱 세밀하게 조정하고 싶을 때 사용한다.
</br>

+) ArgumentResolver와 Interceptor를 비교하기도 하는데, **둘은 서로 지향하는 바가 다르다.** `ArgumentResolver`의 경우 **핸들러의 파라미터에 필요한 객체를 전달하는 것**에 초점을 맞춘다. 반면 `Interceptor`는 **요청이 핸들러로 가기 전에 전처리 되어야 하는 것들을 공통적으로 처리**하는 것에 초점을 맞추고 있다.
</br></br></br>

* 참고
  * Filter
    * https://docs.oracle.com/javaee%2F6%2Fapi%2F%2F/javax/servlet/Filter.html
    * https://www.oracle.com/java/technologies/filters.html
  * Interceptor
    * https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-config/interceptors.html#page-title
    * https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/servlet/HandlerInterceptor.html
