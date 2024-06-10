https://docs.spring.io/spring-framework/reference/testing/spring-mvc-test-framework.html   

## MockMvc
### what is MockMvc?
* `MockMvc`라고 알려진 Spring MVC 테스트 프레임워크는 Spring MVC 애플리케이션 테스트를 지원한다. 
* 전체 Spring MVC 요청 처리를 수행하지만 실행 중인 서버 대신 모의 요청 및 응답 객체를 통해 수행한다.
* MockMvc는 request를 수행하고 response를 확인하기 위해 **자체적으로** 사용될 수 있다.
* 또한 MockMvc는 WebTestClient API를 통해 사용할 수도 있다
    * `WebTestClient`: 서버 애플리케이션 테스트용으로 설계된 **HTTP 클라이언트**
      
### Overview
* 컨트롤러를 인스턴스화하고 종속성을 주입한 후 해당 메서드를 호출하여 Spring MVC에 대한 **단위테스트**를 작성할 수 있다.   
  하지만 이런 테스트에서는 request mapping/data binding/message conversion/type conversion/유효성 검사를 확인하지 않고 `@InitBinder`, `@ModelAttribute`, `@ExceptionHandler`를 포함하지 않는다.
* **Mock MVC는 실행중인 서버없이 Spring MVC 컨트롤러에 대해 보다 완벽한 테스트를 제공하는 것을 목표로 한다.**
* DispatcherServlet을 호출하고 **실행 중인 서버없이** 전체 Spring MVC 요청 처리를 복제하는 spring-test 모듈에서 Servlet API의 “mock” 구현을 전달하여 이를 수행한다.

### Setup Choices
MockMvc를 설정할 수 있는 방법은 두 가지가 존재한다.   
  1. 테스트하려는 컨트롤러를 직접 가리키고 Spring MVC 인프라를 프로그래밍 방식으로 구성하는 방법
  2. Spring MVC와 컨트롤러 인프라가 포함된 Spring configuration을 가리키는 방법

### Performing Requests
MockMvc를 자체적으로 사용하여 request를 수행하고 response를 확인하는 방법
* HTTP 메서드를 사용하는 요청을 수행하는 경우
  ```java
  mockMvc.perform(
    post("/hotels/{id}", 42)
        .accept(MediaType.APPLICATION_JSON)
  );
  ```
* URI 템플릿 스타일로 쿼리 매개변수를 지정하는 경우
  ```java
  mockMvc.perform(
    get("/hotels?thing={thing}", "somewhere")
  );
  ```
* 쿼리 또는 form parameter를 나타내는 서블릿 요청 parameter를 추가하는 경우
  ```java
  mockMvc.perform(
    get("/hotels")
        .param("thing", "somewhere")
  );
  ```
* 대부분의 경우 request URI에서 컨텍스트 경로와 서블릿 경로를 그대로 두는 것이 좋다.
  전체 request URI로 테스트해야하는 경우 아래 예시와 같이 Request mapping이 작동하도록 contextPath 및 servletPath를 적절하게 설정해야 한다.
  ```java
  mockMvc.perform(
    get("/app/main/hotels/{id}")
        .contextPath("/app")
        .servletPath("/main")
  )
  ```
* 수행된 모든 요청에 대해 contextPath 및 servletPath를 설정하는 것이 번거로울 수 있어 아래 예시와 같이 기본 request 속성을 설정할 수 있다.
   ```java
  class MyWebTests {

	  MockMvc mockMvc;

	  @BeforeEach
	  void setup() {
		  mockMvc = standaloneSetup(new AccountController())
			  .defaultRequest(get("/")
			  .contextPath("/app")
			  .servletPath("/main")
			  .accept(MediaType.APPLICATION_JSON)).build();
	  }
  }
  ```
### Defining Expectations
* request를 수행한 후 하나 이상의 `andExpect(..)` 호출을 추가하여 기대치를 정의할 수 있다. 하나의 expectation이 실패하면 다른 expectation은 assert되지 않는다.
  ```java
  mockMvc.perform(
    get("/accounts/1"))
        .andExpect(status().isOk());
  ```
* request를 수행한 후 andExpectAll(..)을 추가하여 여러 expectations를 정의할 수 있다. andExpect(..)와 다르게 andExpectAll(..)은 제공된 모든 expectations가 asserted되고 모든 실패에 대해 추적 및 보고되도록 한다.
  ```java
  mockMvc.perform(
    get("/accounts/1"))
        .andExpectAll(
            status().isOk(),
            content().contentType("application/json;charset=UTF-8")
  );
  ```
**Expectations**는 일반적으로 두 가지 카테고리로 나뉜다.   
assertions의 **첫 번째 카테고리**는 reponse 속성(ex. response status, header 및 context)을 확인하는 것이다. 이것이 assert의 가장 중요한 결과다.   
**두 번째 카테고리**는 response를 넘어서는 것이다. 이 assertions는 어떤 컨트롤러 메서드가 요청을 처리했는지, 예외가 발생했고 처리되었는지, 모델의 콘텐츠가 무엇인지, 어떤 플래시 속성이 추가되었는지 등과 같이 Spring MVC 관련 측면을 검사할 수 있다. 또한 request 및 세션 속성과 같은 특정 서블릿 측면을 검사할 수도 있다.   

### MockMvc vs End-to-End Tests
* `MockMvc`는 스프링 테스트 모듈의 Servlet API 모의 구현을 기반으로 구축되었으며 **실행 중인 컨테이너에 의존하지 않는다.**   
  따라서 실제 클라이언트와 실행 중인 라이브 서버를 사용한 전체 End-to-End 통합 테스트와 비교하면 차이점이 존재한다.
* 이에 대해 생각하는 가장 쉬운 방법은 빈 `MockHttpServletReques`t로 시작하는 것이다. 무엇을 추가하든지 요청이 된다. 놀랍게도 **기본적으로 컨텍스트 경로가 없다.** jsessionid 쿠키가 없다. request, error 또는 비동기 dispatcher가 없다. 따라서 실제 JSP 렌더링이 없다. 대신 “전달된”, “리디렉션된” URL은 MockHttpServletResponse에 저장되며 예상대로 asserted 될 수 있다.
* 이는 JSP를 사용하는 경우 요청이 전달된 JSP 페이지를 확인할 수 있지만 HTML이 렌더링되지 않음을 의미한다. (즉, JSP가 호출되지 않는다.) 그러나 Thymeleaf 및 Freemarker와 같이 전달에 의존하지 않는 다른 모든 렌더링 기술은 HTML을 예상대로 응답 본문에 렌더링한다. `@ResponseBody` 메서드를 통해 JSON, XML 및 기타 형식을 렌더링하는 경우에도 마찬가지이다.
* 또는 `@SpringBootTest`**를 사용하여 Spring Boot의 전체 End-to-End 통합 테스트 지원을 고려할 수도 있다.**
