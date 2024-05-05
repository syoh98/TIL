https://docs.spring.io/spring-framework/reference/testing.html   
➡️ Spring이 제공하는 공식문서를 읽고 정리한 내용

## 📂 단위테스트
### 📝 IoC 원칙
* DI를 사용하면 기존 J2EE/Java EE개발보다 컨테이너에 대한 코드 의존도가 낮아집니다.
* 애플리케이션을 구성하는 POJO는 Spring이나 다른 컨테이너 없이 new연산자를 사용하여 인스턴스화된 개체를 사용하여 JUnit 또는 TestNG 테스트에서 테스트를 할 수 있어야 합니다.
* mock 객체를 다른 중요한 테스트 기술과 함께 사용하여 별도로 테스트 할 수 있습니다.
* 단위테스트를 실행하는 동안 데이터에 액세스 할 필요없이 DAO 또는 repository interface를 stub하거나 mocking하여 서비스 계층 개체를 테스트 할 수 있습니다.
* 실제 단위 테스트는 설정할 런타임 인프라가 없기 때문에 일반적으로 매우 빠르게 실행됩니다.
### Mock Objects   
Spring에는 mocking 전용 패키지가 포함되어 있습니다.   
* **JNDI**
  * `org.springframework.mock.jndi` 패키지에는 JNDI SPI의 부분 구현이 포함되어 있어 test suites 또는 독립형 애플리케이션을 위한 간단한 JNDI 환경을 설정하는 데 사용할 수 있습니다.
  * 예를 들어 JDBC DataSource 인스턴스가 Jakarta EE 컨테이너에서와 마찬가지로 테스트 코드에서 동일한 JNDI 이름에 바인딩되면 수정 없이 테스트 시나리오에서 애플리케이션 코드와 구성을 모두 재사용할 수 있습니다.
* **Servlet API**
  * `org.springframework.mock.web` 패키지에는 웹 컨텍스트, 컨트롤러 및 필터를 테스트하는 데 유용한 Servlet API mock 객체가 포함되어 있습니다.
  *  이러한 목 객체는 Spring의 웹 MVC 프레임워크와 함께 사용하는 것을 목표로 하며 일반적으로 동적 목 객체(예: EasyMock) 또는 대체 서블릿 API 목 객체(예: MockObjects)보다 사용하기 더 편리합니다.
* **Spring Web Reactive**
  *  `org.springframework.mock.http.server.reactiv`e 패키지에는 WebFlux 애플리케이션에서 사용하기 위한 ServerHttpRequest 및 ServerHttpResponse의 모의 구현이 포함되어 있습니다.   
     `org.springframework.mock.web.server` 패키지에는 모의 요청 및 응답 객체에 의존하   는 모의 ServerWebExchange가 포함되어 있습니다.
  *  MockServerHttpRequest와 MockServerHttpResponse는 모두 서버별 구현과 동일한 추상 기본 클래스에서 확장되며 동작을 공유합니다. 예를 들어 모의 요청은 일단 생성되면 변경할 수 없지만 ServerHttpRequest의 mutate() 메서드를 사용하여 수정된 인스턴스를 생성할 수 있습니다.
  *  mock response가 write를 올바르게 구현하고 write completion handle(즉, Mono<Void>)을 반환하기 위해 기본적으로 데이터를 버퍼링하고 생성하는 cache().then()이 포함된 Flux를 사용합니다.   
     테스트의 assertions에 사용할 수 있습니다. 애플리케이션은 사용자 정의 쓰기 기능을 설정할 수 있습니다(ex)infinite stream test)
  *  WebTestClient는 HTTP 서버 없이 WebFlux 애플리케이션 테스트를 지원하기 위해 mock request 및 response를 기반으로 합니다. 클라이언트는 실행 중인 서버에서 end-to-end 테스트에도 사용할 수 있습니다.
### 📝 단위 테스트 지원 클래스
* **일반 테스트 유틸리티**
  * `org.springframework.test.util`패키지에는 단위 및 통합 테스트에 사용되는 여러 유틸리티가 포함되어 있습니다.
  * **AopTestUtils**는 AOP 관련 유틸리티 메서드 모음입니다. 이러한 메소드를 사용하여 하나 이상의 Spring 프록시 뒤에 숨겨진 기본 대상 객체에 대한 참조를 얻을 수 있습니다.
    예를 들어 EasyMock 또는 Mockito와 같은 라이브러리를 사용하여 Bean을 동적 mock으로 구성하고 mock이 Spring 프록시에 참조된 경우 기본 mock에 직접 액세스하여 기대치를 구성하고 확인을 수행해야 할 수 있습니다.
  * **ReflectionTestUtils**는 reflection 기반 유틸리티 메서드 모음입니다. 상수 값을 변경하거나, 비공개 필드를 설정하거나, 비공개 setter 메서드를 호출하거나, 애플리케이션 코드를 테스트할 때 non-public 구성 또는 lifecycle 콜백 메서드를 호출해야 하는 테스트 시나리오에서 이 메서드를 사용할 수 있습니다.
  * [예시]
    * 도메인 엔터티의 속성에 대한 `public setter` 메서드와 달리 private or protected field 액세스를 허용하는 ORM 프레임워크(예: JPA 및 Hibernate)
    * Spring은 private or protected 필드, setter 메소드 및 구성 메소드에 대한 DI을 제공하는 `@Autowired`, `@Inject` 및 `@Resource`와 같은 주석을 지원합니다.
    * 수명 주기 콜백 메서드에 `@PostConstruct` 및 `@PreDestroy`와 같은 주석을 사용합니다.
* **Spring MVC 테스트 유틸리티**
  * `org.springframework.test.web` 패키지에는 JUnit, TestNG 또는 Spring MVC `ModelAndView` 객체를 처리하는 단위 테스트를 위한 기타 테스트 프레임워크와 함께 사용할 수 있는 `ModelAndViewAssert`가 포함되어 있습니다.
</br>

## 📂 통합테스트
Spring Framework 지원
* **이 테스트는 애플리케이션 서버나 기타 배포 환경에 의존하지 않습니다.** 이러한 테스트는 **단위 테스트보다 실행 속도가 느리지만** 애플리케이션 서버 배포에 의존하는 동등한 Selenium 테스트나 원격 테스트보다 훨씬 빠릅니다.
* 단위 및 통합 테스트 지원은 annotation 기반 Spring TestContext 프레임워크의 형태로 제공됩니다. TestContext 프레임워크는 사용 중인 **실제 테스트 프레임워크와 무관**하므로 JUnit, TestNG 등을 포함한 다양한 환경에서 테스트를 할 수 있습니다.
### 📝 통합 테스트의 목표
* **테스트 간 Spring IoC 컨테이너 캐싱을 관리**
  * Spring TestContext 프레임워크는 Spring ApplicationContext 인스턴스 및 WebApplicationContext 인스턴스의 일관된 로딩과 해당 컨텍스트의 캐싱을 제공합니다.
    로드된 컨텍스트의 캐싱에 대한 지원은 중요합니다. 시작 시간이 문제가 될 수 있기 때문입니다. 즉, Spring 자체의 오버헤드 때문이 아니라 Spring 컨테이너에 의해 인스턴스화되는 객체가 인스턴스화하는 데 시간이 걸리기 때문입니다.
    예를 들어, 50-100개의 Hibernate 매핑 파일이 있는 프로젝트는 매핑 파일을 로드하는 데 10~20초가 걸릴 수 있으며, 모든 테스트 fixture에서 테스트를 실행하기 전에 해당 비용이 발생하면 전반적인 테스트 실행 속도가 느려져 개발자 생산성이 저하됩니다.
* **test fixture 인스턴스의 DI를 제공**
  * TestContext 프레임워크가 애플리케이션 컨텍스트를 로드할 때 DI를 사용하여 선택적으로 테스트 클래스의 인스턴스를 구성할 수 있습니다.
    이는 애플리케이션 컨텍스트에서 사전 구성된 Bean을 사용하여 test fixture를 설정하기 위한 편리한 메커니즘을 제공합니다. 여기서 가장 큰 이점은 **다양한 테스트 시나리오**(예: Spring 관리 객체 그래프, 트랜잭션 프록시, DataSource 인스턴스 등 구성)에서 **애플리케이션 컨텍스트를 재사용할 수 있으므로 개별 테스트를 위해 복잡한 테스트 픽스처 설정을 복제할 필요가 없다는 것**입니다.
  * [예시]   
    예를 들어, Title 도메인 엔터티에 대한 데이터 액세스 논리를 구현하는 클래스(HibernateTitleRepository)가 있는 시나리오를 생각해 보세요. 우리는 다음 영역을 테스트하는 통합 테스트를 작성하려고 합니다.
    * **Spring 구성**: 기본적으로 HibernateTitleRepository 빈 구성과 관련된 모든 것이 정확하고 존재합니까?
    * **Hibernate 매핑 파일 구성**: 모든 것이 올바르게 매핑되었으며 올바른 지연 로딩 설정이 적용되어 있습니까?
    * **HibernateTitleRepository의 논리**: 이 클래스의 구성된 인스턴스가 예상대로 작동합니까?
* **통합 테스트에 적합한 트랜잭션 관리를 제공**
  * 실제 데이터베이스에 액세스하는 테스트에서 흔히 발생하는 문제 중 하나는 지속된 저장 상태에 미치는 영향입니다. **개발 데이터베이스를 사용하는 경우에 상태 변경은 향후 테스트에 영향을 미칠 수 있습니다.** 또한 영구 데이터 삽입 또는 수정과 같은 많은 작업은 트랜잭션 외부에서 수행(또는 확인)될 수 없습니다.
  * **TestContext 프레임워크는 이 문제를 해결합니다. 기본적으로 프레임워크는 각 테스트에 대해 트랜잭션을 생성하고 롤백합니다.** 트랜잭션이 존재한다고 가정할 수 있는 코드를 작성할 수 있습니다. 테스트에서 트랜잭션으로 프록시된 개체를 호출하면 해당 개체는 구성된 트랜잭션 의미 체계에 따라 올바르게 작동합니다.   
    또한, 테스트를 위해 관리되는 트랜잭션 내에서 테스트 메소드가 실행 중 선택된 테이블의 내용을 삭제하는 경우 기본적으로 트랜잭션은 롤백되며, 데이터베이스는 테스트를 수행하기 전의 상태로 돌아갑니다.
    테스트의 애플리케이션 컨텍스트에 정의된 PlatformTransactionManager 빈을 사용하여 테스트에 트랜잭션 지원이 제공됩니다.
  * 트랜잭션을 커밋하려는 경우(특이하지만 특정 테스트를 통해 데이터베이스를 채우거나 수정하려는 경우 가끔 유용함) **`@Commit` 주석을 사용하여 롤백하는 대신 트랜잭션이 커밋되도록 TestContext 프레임워크에 지시할 수 있습니다.**
* **개발자가 통합 테스트를 작성하는데 도움을 주는 Spring 관련 기본 클래스를 제공**
  * Spring TestContext Framework는 통합 테스트 작성을 단순화하는 여러 추상 지원 클래스를 제공합니다. 이러한 기본 테스트 클래스는 테스트 프레임워크에 대한 정의된 연결은 물론 다음 항목에 액세스할 수 있는 편리한 인스턴스 변수 및 메서드를 제공합니다.
    * **ApplicationContext**: 명시적인 빈 조회를 수행하거나 컨텍스트 상태를 전체적으로 테스트하기 위함
    * **JdbcTemplate**: 데이터베이스를 쿼리하기 위해 SQL 문을 실행하기 위함. 이러한 쿼리를 사용하면 데이터베이스 관련 애플리케이션 코드 실행 전후에 데이터베이스 상태를 확인할 수 있으며 Spring은 이러한 쿼리가 애플리케이션 코드와 동일한 트랜잭션 범위에서 실행되도록 보장합니다.
