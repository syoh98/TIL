## 🤔 그럼 Scale out 방식의 문제점인 데이터 정합성을 어떻게 해결할 수 있을까?
### Sticky Session
<img src="https://github.com/syoh98/TIL/assets/76934280/c40f03ce-9316-40fe-b9c3-f8f5453e6cfb" width="700"/></br>
**로드밸런서가 특정 세션의 요청을 처음 처리한 서버로만 보내는 것**이다.   
클라이언트의 모든 요청은 로드밸런서를 거쳐가고, 이 과정에서 클라이언트의 **Cookie**나 **IP tracking**의 정보로 동일한 클라이언트인지 판단 후 세션이 생성된 서버로 라우팅되어 클라이언트는 동일한 세션을 제공받는다.   
* 장점
  * 서버들끼리 세션의 정합성을 맞출 필요가 없다. (세션 정합성을 맞추기 위해 어떠한 작업이 일어난다면 그 작업 또한 내부적으로 트래픽을 발생시킬 수 있다.)
* 단점
  * 특정 서버에만 트래픽이 몰려 과부하가 발생할 수 있다. 이 경우 Scale out의 다중 서버 환경의 장점을 잃어버린다.
  * 특정 서버가 예기치 않게 종료될 경우, 종료된 서버와 바인딩 되어있던 클라이언트의 세션 정보가 소실될 수 있다.
   
### Session Clustering
<img src="https://github.com/syoh98/TIL/assets/76934280/9560dc37-170a-4ae8-9a52-eea2fcd97a1c" width="500"/></br>
**여러 WAS에 대한 세션을 하나의 세션으로 관리하는 것**이다.   
Sticky Session의 단점 중 하나인 운영 중인 서버가 다운될 경우, 다른 서버들이 다운된 서버의 세션을 갖고 있지 않은 문제를 해결할 수 있다.   
WAS마다 세션 클러스팅의 방식이 다르다.   
➡️ Spring boot의 내장 WAS인 Tomcat의 Clustering을 확인해보자.   
* **DeltaManager(all-to-all)**   
  <img src="https://github.com/syoh98/TIL/assets/76934280/f1be28d2-d1e3-4cd7-a2ba-2dbe9a1f8cbf" width="600"/></br>
  * DeltaManager가 모든 WAS에 동일한 세션을 복제하는 방법이다.
  * 모든 WAS에 동일한 세션이 복제되어 있기 때문에 특정 서버에 트래픽이 몰려 서버가 다운되더라도 다른 서버가 동작하기 때문에 세션 불일치에 대한 문제가 해결된다.
  * 하지만 세션을 모든 서버에 복제하는 과정에서 트래픽이 발생한다. 서버가 추가되는 경우 다시 세션을 서버에 복제해야하고 이 또한 트래픽 증가로 성능 저하가 발생한다.
    * 따라서, Tomcat 공식문서에서도 4대 이상의 WAS에서는 이 방식을 권장하지 않는다.
      * https://tomcat.apache.org/tomcat-8.5-doc/cluster-howto.html
      * `This works great for smaller clusters, but we don't recommend it for larger clusters — more than 4 nodes or so.`
* **BackupManager(Primary-Secondary)**   
  <img src="https://github.com/syoh98/TIL/assets/76934280/b2f7f795-3f75-4457-9fd5-d1bda52ff016" width="700"/></br>
  * BackupManager가 **세션을 모든 서버에 복제하지 않고 백업(Secondary) 서버에만 복제**를 하는 방법이다.
  * 클라이언트의 요청이 들어오면 해당 요청을 처리한 `Primary 서버`에 세션을 생성하고, `Secondary 서버`(백업 서버)에만 **완전한 세션 복제**를 진행한다.
    * 나머지 `Proxy 서버`들은 세션의 key와 key의 주소 값만을 가진다.
    * 만약 Proxy 서버에 클라이언트의 요청이 들어오면 Primary 서버에 요청을 보낸다.
  * 하지만 Primary 서버가 다운 됐을 경우, 로드밸런서는 다른 서버에게 트래픽을 전달하고 그 서버가 Proxy 서버라면 세션 정보를 가지고 있는 노드에게 세션 value를 가져올 것이다.
    * 세션 value를 응답받게 되면 그 때부터 요청을 처리한 Proxy 서버는 Primary 서버가 되고 모든 세션을 복제한다.
    * 데이터 정합성 문제 해결했지만 결국 **불필요한 복제로 서버의 메모리 사용량이 증가하여 서버의 성능이 저하되는 문제는 해결되지 않는다.**
* ➡️ 위의 방법 모두 **서버가 세션이라는 상태(데이터)를 가지며**, 확장하는 서버에도 데이터 정합성을 맞춰줘야한다.
* ➡️ 그럼, **서버가 상태(데이터)를 가지지 않는다면?** 데이터의 정합성을 맞춰줄 필요가 없게 되는 것이고 이를 구현하는 방법에는 세션 저장소를 **서버가 아닌 외부로 분리**하는 방법(=`Session Storage`)이 있다.

## 세션 저장소(Session Storage)
<img src="https://github.com/syoh98/TIL/assets/76934280/1e9254f1-1ac5-4e17-a7f3-2ccab01ede90" width="600"/></br>
**세션을 서버의 메모리에 저장하지 않고, 외부의 저장소에 저장하고 필요 시 조회하는 방법**이다.   
외부 저장소에 모든 서버들의 세션 정보를 모아서 저장할 수 있기 때문에 **세션 불일치 문제(데이터 정합성)를 해결**한다.   
Stick Session처럼 특정 클라이언트의 요청을 특정 서버에 전달하도록 고정할 필요가 없기 때문에 특정 서버에 대한 **트래픽 과부하 문제를 해결**한다.   
하지만, 외부 저장소의 예기치 못한 종료로 **모든 세션 데이터를 소실할 수 있다는 단점**이 있다.
</br></br>
* 참고
  * https://liasn.tistory.com/3
  * https://learn.microsoft.com/ko-kr/dotnet/architecture/cloud-native/infrastructure-resiliency-azure
  * https://smjeon.dev/web/sticky-session/
  * https://velog.io/@sjhello/세션-스토리지로-어떤-것을-사용할-수-있을까
