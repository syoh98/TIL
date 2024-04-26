## ✏️ JMX란?
* **J**ava **M**anagement E**x**tensions의 약자이다.
* JMX의 4단계 레벨
  * instrumentation Level
    * 하나 이상의 `MBeans`를 제공한다
    * 이 `MBeans`에서 필요한 리소스들의 정보를 취합하여 에이전트로 전달하는 역할을 한다.
    * API 를 통해서 최소한의 노력으로 MBeans의 처리 내용을 전달할 수 있도록 한다.
  * Agent Level
    * 에이전트를 구현하기 위한 스펙이 제공된다.
    * 에이전트는 리소스를 관리하는 역할을 수행한다.
    * 보통 에이전트는 모니터링이 되는 서버와 같은 장비에 위치한다.
    * JMX의 데이터를 관리하는 관리자와 연계를 위한 어댑터나 커넥터를 이 레벨에서 제공한다.
  * Distributed Services Level
    * 분산 서비스 레벨은 JMX 관리자를 구현하기 위한 인터페이스와 컴포넌트를 제공한다.
    * 여러 에이전트에서 제공하는 정보를 관리할 수 있는 화면과 같은 부분을 여기서 담당한다.
  * Additional Management Protocol APIs
</br>

## ✏️ XBean에 대해서 조금만 더 자세히 알아보자
* 🫘 MBean의 종류
  * 표준 MBean: 변경이 많지 않은 시스템을 관리하기 위한 MBean이 필요한 경우 사용한다.
  * 동적 MBean: 애플리케이션이 자주 변경되는 시스템을 관리하기 위한 MBean이 필요한 경우 사용한다.
  * 모델 MBean: 어떤 리소스나 동적으로 설치가 가능한 MBean이 필요한 경우 사용한다.
  * 오픈 MBean: 실행 중에 발견되는 객체의 정보를 확인하기 위한 MBean이 필요할 때 사용한다.
* 에이전트가 제공해야 하는 기능
  * 현재 서버에 있는 MBean의 다음 기능들을 관리
    * MBean의 속성값을 얻고, 변경한다.
    * MBean에서 수행된 정보를 받는다.
  * 모든 MBean에서 수행된 정보를 받는다.
  * 기존 클래스나 새로 다운로드된 클래스의 새로운 MBean을 초기화하고 등록한다.
  * 기존 MBean들의 구현과 관련된 관리 정책을 처리하기 위해서 에이전트 서비스를 사용되도록 한다.
</br>

## ✏️ Visual VM을 통한 JMX 모니터링
* JDK를 설치하면 bin 디렉터리가 만들어지는데, 모니터링을 위한 `jconsole`과 `jvisualvm`이라는 툴이 존재한다.
  * `jconsole`은 구식이고 `Visual VM`이 최신 툴이다.
* 이 두가지 툴 모두 JMX의 데이터를 볼 수 있도록 만들어졌다.
</br>

## ✏️ 원격으로 JMX를 사용하기 위해서는...
* 원격지에 있는 서버와 통신을 하여 JMX 모니터링을 하기 위해서는 서버나 자바 애플리케이션을 시작할 때 VM 옵션을 지정해야 한다.
* 옵션
  * -Dcom.sun.management.jmxremote.port=9003
  * -Dcom.sun.management.jmxremote.ssl=false
  * -Dcom.sun.management.jmxremote.authenticate=false
  * ➡️ 이렇게 지정하면 아이디와 패스워드를 지정할 필요 없이 서버의 IP와 포트만으로 서버에 원격으로 접속할 수 있다.
  * 아이디와 패스워드를 지정하여 접속할 수 있도록 변경하려면,,
    * -Dcom.sun.management.jmxremote.port=9003
    * -Dcom.sun.management.jmxremote.password.file=/파일위치/conf/jmxremote.password
    * -Dcom.sun.management.jmxremote.access.file=/파일위치/conf/jmxremote.access
    * -Dcom.sun.management.jmxremote.ssl=false
</br>

## ✏️ 정리
* 상용 툴을 사용하지 않고 WAS를 모니터링하기 위한 기술 중 **서버의 데이터를 가장 많이 확인할 수 있는 것이 JMX**이다.
* 또한 스스로 추가적인 기능을 개발하여 서버를 모니터링 할 수도 있다.
* 하지만 모든 모니터링 툴이 그렇듯이, 모니터링 툴로 인한 부하는 절대 무시할 수 없다.
* 서버의 CPU 및 메모리, 네트워크 리소스에 여유가 없는 상황에서는 주의해서 사용하자.
