https://docs.spring.io/spring-boot/docs/1.5.3.RELEASE/reference/html/boot-features-testing.html

## @SpringBootTest 어노테이션이란 뭘까?
* `@SpringBootTest`는 Spring Boot에 기본 구성 클래스(예: `@SpringBootApplication`이 포함된 클래스)를 찾고 이를 사용하여 **Spring 애플리케이션 컨텍스트를 시작하도록 지시**한다.
* ➡️ 따라서 `@SpringBoot` 어노테이션을 사용하면 손쉽게 **통합 테스트**를 위한 환경을 구축할 수 있다.
</br>

### 테스트 구체화
`SpringBootTest`의 **webEnvironment**속성으로 웹테스트 환경을 설정할 수 있다.
* **MOCK**
  * WebApplicationContext를 로드하고 모의 서블릿 환경을 제공합니다.
  * 해당 어노테이션 사용 시 임베디드 서블릿 컨테이너가 시작되지 않습니다. 
  * 서블릿 API가 클래스 경로에 없으면 이 모드는 웹이 아닌 일반 ApplicationContext 생성으로 투명하게 대체됩니다.   
    애플리케이션의 MockMvc 기반 테스트를 위해 @AutoConfigureMockMvc와 함께 사용할 수 있습니다.
* **RANDOM_PORT**
  * EmbeddedWebApplicationContext를 로드하고 **실제 서블릿 환경을 제공**합니다.
  * 임베디드 서블릿 컨테이너가 시작되고 임의의 포트에서 수신 대기합니다.
* **DEFINED_PORT**
  * EmbeddedWebApplicationContext를 로드하고 **실제 서블릿 환경을 제공**합니다.
  * 내장된 서블릿 컨테이너가 시작되고 정의된 포트(예: application.properties 또는 기본 포트 8080)에서 수신됩니다.
* **NONE**
  * SpringApplication을 사용하여 ApplicationContext를 로드하지만 **서블릿 환경(모의 또는 기타)을 제공하지 않습니다.**
