**✏️ URL과 @RequestMapping 연결하기**
* 웹 상에서 클라이언트의 요청은 모두 `URL` 기반으로 이루어진다.
* 웹 서버는 클라이언트가 요청한 URL 정보를 이용해 서버의 특정 구성 요소에서 서비스를 처리한 후 그 결과를 클라이언트에게 응답으로 보내준다.
* 스프링 MVC에서는 `@Controller` 어노테이션이 붙은 클래스 안에 `@RequestMapping` 어노테이션이 붙은 메서드에서 클라이언트 요청을 처리하게 된다.
* 예를들어
  * 클라이언트가 http://localhost:8080/mvc/ 라고 URL을 입력했을 경우
  * 웹 서버에 서비스를 요청하고, 서블릿 컨테이너가 mvc라고 하는 웹 컨텍스트를 찾는다
  * 해당 웹 컨텍스트는 스프링 `ApplicaitonContext`에게 URL 중에 /를 처리할 수 있는, 즉 `@RequestMapping(value="/")`를 가진메서드에게 처리를 위임한다
* 💡`@RequestBody`: 메서드에서 반환하는 문자열을 그대로 클라이언트, 즉 브라우저에게 전달하라는 뜻
* 💡 모델: 컨트롤러에서 뷰로 전달해주는 정보. 모델을 생성하는 것은 `DispatcherServlet`의 역할. DispatcherServlet이 생성한 모델에 대한 참조변수는 `@RequestMapping` 어노테이션이 붙는 메서드에서 인자를 선언하기만 하면 자동으로 받을 수 있다.

**✏️ 서비스 구현**
* 모델(Model): 컨트롤러에서 뷰로 전달해주는 정보이다. 스프링 MVC에서 모델을 생성하는 것은 `DispatherServlet`의 역할이다.
* `DispatherServlet`이 생성한 모델에 대한 참조 변수는 `@RequestMapping` 어노테이션이 붙은 메서드에서 인자를 선언하기만 하면 자동으로 받을 수 있다.
* 💡`@PathVariable`
  * 경로변수
  * 경로 변수를 메서드의 인자로 사용하려면 `@PathVariable` 어노테이션을 인자에 지정하기만 하면 된다.
  * 기존 방식에서 `request.getParameter("seq")`를 다시 `int`형으로 변환하는 작업을 스프링 MVC가 처리해준다.
* 💡`@Valid`: 자바에서 지원하는 유효성 검증 기능
* 💡`@SessionAttributes("Session에 저장할 객체명")`
  * 모델(Model) 정보를 HTTP 세션에 저장해주는 어노테이션
  * HttpSession을 직접 사용할 수도 있지만, 해당 어노테이션을 사용하여 설정한 이름에 해당하는 모델 정보를 자동으로 세션에 넣을 수 있다.
  * 여러 화면에서 사용해야 하는 객체를 공유할 때 사용한다.
  * `@ModelAttribute`: 세션에서 저장한 객체를 활용하는 메서드 인자에 `@ModelAttribute` 어노테이션을 지정한다.
  * 세션은 서버의 메모리 자원이기에 세션에서 더 이상 사용하지 않게 됐을 때 스프링 MVC가 제공하는 SessionStatus 객체의 `setComplete()` 메서드를 이용해 더는 필요치 않은 객체를 세션에서 제거하면 된다.
