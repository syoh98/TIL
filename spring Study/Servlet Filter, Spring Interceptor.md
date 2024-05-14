공통 관심사항을 처리하는 방법에는 Spring AOP, Filter, Interceptor가 있다.    
그 중에서도 웹과 관련된 관심사항은 파라미터에 ServeletRequest, ServletResponse를 제공해주어 URL 정보, HTTP 헤더를 직접 조작할 수 있는 Filter와 Interceptor가 유리하다.   
   
## ⏺️ Servlet Filter
Dispatcher Servlet에 요청이 전달되기 전, 후에 부가작업을 처리하는 객체이다.   
### 📝 메서드
![image](https://github.com/syoh98/TIL/assets/76934280/46bd43a3-2660-4d8f-8a48-110f303d3f77)
init(), destory()는 선택적으로 오버라이딩 할 수 있다. doFilter()는 필수적으로 오버라이딩 해야한다.
* init()   
  ![image](https://github.com/syoh98/TIL/assets/76934280/3adedf27-0ee0-4d19-9f6f-0061c21016d3)
  * 필터가 생성될 때 딱 한번만 호출된다.
  * 커넥션 풀 start → filter 호출 순서
* doFilter()   
  ![image](https://github.com/syoh98/TIL/assets/76934280/ea88e849-0bdc-40f7-a092-841ce4407dc9)
  * 파라미터인 request와 response로 HTTP 정보들을 읽을 수 있다.
  * `init()`과 다르게 요청에 들어올 때마다 실행이 되어 인증 또는 부가적인 작업의 경우 `doFilter()` 메서드에서 로직을 구현한다.
* destroy()
  * 필터가 소멸될 때 딱 한번만 호출된다.
  * filter 소멸 → 커넥션 풀 Shutdown 순서
   
### 📝 서블릿 필터를 등록하는 방법
* @Component
* @WebFilter + @ServletCompomentScan
* FilterRegistrationBean

### 📝 서블릿 필터의 동작방식   
FilterChain이 동작할 때 ApplicationFilterChain이 실행된다.   
![image](https://github.com/syoh98/TIL/assets/76934280/5e5342b2-7c0a-45b1-b1b8-d9b947b0382b)

## ⏺️ Spring Interceptor   
Dispatcher Servlet이 Controller를 호출하기 전/후 요청에 대해 부가적인 작업을 처리하는 객체이다.
### 📝 메서드   
![image](https://github.com/syoh98/TIL/assets/76934280/37f0c84e-da53-41d2-92a6-121de25b329b)
preHandle(), postHandle(), afterCompletion() 모두 디폴트 메서드이기 때문에 선택적으로 오버라이딩이 가능하다.
* preHandle()
  * Handler가 실행되기 전 실행되는 메서드
* postHandle()
  * Handler가 실행된 이후에 실행되는 메서드
  * 파라미터로 ModelView를 받기 때문에 ModelAndVoew에 대해 추가적인 작업을 하고싶은 경우 사용한다.
* afterCompletion()
  * Handler 이후에 실행되는 메서드
  * 파라미터로 Exception이 넘어오기 때문에 비즈니스 로직의 예외가 발생한 경우 afterCompletion()을 통해 예외를 처리할 수 있다.
### 📝 스프링 인터셉터를 등록하는 방법
![image](https://github.com/syoh98/TIL/assets/76934280/345d1c81-ed40-4e19-a962-750db8e26a89)
* addInterceptors()로 인터셉터를 등록한다.
* 호출 시점
  * 핸들러 조회 → 알맞은 핸들러 어댑터를 가져옴 → preHandle → 핸들러 어댑터를 통해 핸들러 실행(비즈니스 로직) → postHandle → view 관련 처리 → afterCompletion
### 📝 스프링 인터셉터의 동작방식
* DispatcherServlet.class   
  ![image](https://github.com/syoh98/TIL/assets/76934280/a75efd31-c1fe-476d-8187-fec5a019dc65)
* DispatcherServlet.Class → `doDispatch()`   
  ![image](https://github.com/syoh98/TIL/assets/76934280/57a4c650-fe5d-4120-9e3b-c03dc4e5ae40)
  ![image](https://github.com/syoh98/TIL/assets/76934280/d2fd8135-6b8e-4fd3-baa5-a34810e6a5cb)
  ![image](https://github.com/syoh98/TIL/assets/76934280/c546c500-5d27-4f0a-bada-d628c98a71f0)
  ![image](https://github.com/syoh98/TIL/assets/76934280/378764f7-c277-44c2-8e65-b8b1e8e46f50)
    
## ⏺️ Filter와 Interceptor의 차이
|Filter|Intercetor|
|------|---|
|자바 표준 스펙|스프링이 제공하는 기술|
|다음 필터를 실행하기 위해 개발자가 명시적으로 작성해줘야 한다.|다음 인터셉터를 실행하기 위해 개발자가 신경써야 하는 부분이 없다.|
|ServletRequest, ServletReponse를 필터 체이닝 중간에 새로운 객체로 바꿀 수 있다.|ServletRequest, ServletResponse를 인터셉터 체이닝 중간에 새로운 객체로 바꿀 수 없다.|
|필터에서 예외가 발생하면 `@ControllerAdvice`에서 처리하지 못한다.|인터셉터에서 예외가 발생하면 `@ControllerAdvice`에서 처리가 가능하다.|
</br>

* 참고
  * https://www.youtube.com/watch?v=v86B35pwk6s&t=607s
