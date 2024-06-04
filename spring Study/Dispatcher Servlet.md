## #️⃣ Dispatcher Servlet
HTTP로 들어오는 요청을 가장 먼저 받아 **적합한 컨트롤러에 위임**해주는 `프론트 컨트롤러`이다.
* **✏️ 프론트 컨트롤러란?**   
  <img src="https://github.com/syoh98/TIL/assets/76934280/e740c22c-da48-4a72-9b8b-ee1048d1629c" width="600"/></br>
  ➡️ 서블릿 컨테이너(ex. tomcat) 맨 앞에서 클라이언트의 모든 요청을 받아 처리해주는 컨트롤러이다.
  
### 🤔 왜 사용할까?
Dispatcher Servlet이 등장하기 전에는 모든 요청에 매핑되는 서블릿을 HttpServlet을 상속받아서 일일이 생성했었다.   
하지만 Dispatcher Servlet이 등장하면서 모든 요청을 먼저 받아 적합한 컨트롤러로 위임해주어 해당 작업이 필요 없어졌다.

### ✏️ 동작 과정
![image](https://github.com/syoh98/TIL/assets/76934280/0edb202a-29b7-4500-8f94-91a4768b5040)
1. `Dispatcher Servlet`이 모든 요청을 받는다.
2. 요청 정보에 대해 `HandlerMapping`에 위임하여 처리할 Handler(Controller)를 찾는다.
3. 2번에서 찾은 Handler를 수행할 수 있는 `Handler Adpater`를 찾는다.
4. `Handler Adapter`는 Controller에 비즈니스 로직 처리를 호출한다.
5. Controller는 비즈니스 로직을 수행하고, 처리 결과를 Model에 설정하며 Handler Adapter에게 view name을 반환한다.
   * 모델 반환 시 view가 렌더링 되고, 그렇지 않은 경우(ex.`@RestController`)에는 view가 렌더링 되지 않는다.
6. 5번에서 반환받은 view name을 `view Resolver`에게 전달하고, `view Resolver`는 해당하는 view 객체를 반환한다.
7. `Dispatcher Servlet`은 view에게 model을 전달하고 화면 표시를 요청한다.
8. 최종적으로 서버의 응답을 클라이언트에게 반환한다.   
</br>

참고
* https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/servlet/DispatcherServlet.html
* https://zzang9ha.tistory.com/441
