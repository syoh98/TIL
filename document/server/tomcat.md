https://tomcat.apache.org/tomcat-9.0-doc/cluster-howto.html
# Clustering/Session Replication How-To
## **For the impatient**

`<Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"/>`

클러스터링을 활성화하려면 <Engine> 또는 <Host> 요소에 추가하세요.

위 구성을 사용하면 DeltaManager를 사용하여 세션 델타를 복제하는 **all-to-all** 세션 복제가 활성화됩니다. **all-to-all**이란 **모든 세션이 클러스터의 다른 모든 노드에 복제된다는 의미**입니다. 이는 소규모 클러스터에 적합하지만 노드가 4개 이상인 대규모 클러스터에는 권장되지 않습니다. 또한 DeltaManager를 사용할 때 Tomcat은 애플리케이션이 배포되지 않은 노드를 포함하여 모든 노드에 세션을 복제합니다.
이러한 문제를 해결하려면 BackupManager를 사용하는 것이 좋습니다. BackupManager는 **세션 데이터를 하나의 백업 노드와 애플리케이션이 배포된 노드에만 복제**합니다. DeltaManager로 실행되는 간단한 클러스터가 있으면 클러스터의 노드 수를 늘리면서 BackupManager로 마이그레이션하고 싶을 것입니다.

## **Cluster Basics**

Tomcat 9 컨테이너에서 세션 복제를 실행하려면 다음 단계를 완료해야 합니다.

모든 세션 속성은 **java.io.Serializable**를 구현해야 합니다.
server.xml에서 **Cluster** 요소의 주석 처리를 제거합니다.
사용자 정의 클러스터 밸브를 정의한 경우 server.xml의 Cluster 요소 아래에도 **ReplicationValve**가 정의되어 있는지 확인하십시오.
Tomcat 인스턴스가 동일한 시스템에서 실행 중인 경우 **Receiver.port** 속성이 각 인스턴스에 대해 고유한지 확인하십시오. 대부분의 경우 Tomcat은 4000-4100 범위에서 사용 가능한 포트를 자동 감지하여 스스로 이 문제를 해결할 만큼 똑똑합니다.
**web.xml**에 `<distributable/>` 요소가 있는지 확인하세요.
mod_jk를 사용하는 경우 jvmRoute 속성이 Engine `<Engine name="Catalina" jvmRoute="node01" >`에 설정되어 있고 jvmRoute 속성 값이 Workers.properties의 작업자 이름과 일치하는지 확인하세요.
모든 노드가 동일한 시간을 갖고 NTP 서비스와 동기화되는지 확인하세요!
로드 밸런서가 고정 세션 모드로 구성되어 있는지 확인하세요.
로드 밸런싱 장에서 설명한 것처럼 다양한 기술을 통해 로드 밸런싱을 수행할 수 있습니다.

참고: 세션 상태는 쿠키에 의해 추적되므로 URL이 외부에서 동일하게 보여야 합니다. 그렇지 않으면 새 세션이 생성됩니다.

클러스터 모듈은 Tomcat JULI 로깅 프레임워크를 사용하므로 일반 login.properties 파일을 통해 로깅을 구성할 수 있습니다. 메시지를 추적하려면 `org.apache.catalina.tribes.MESSAGES` 키에 대한 로깅을 활성화하면 됩니다.

## **Overview**

Tomcat에서 세션 복제를 활성화하려면 세 가지 다른 경로를 따라 정확히 동일한 결과를 얻을 수 있습니다.

1. 세션 지속성 사용 및 세션을 공유 파일 시스템에 저장(PersistenceManager + FileStore)
2. 세션 지속성 사용 및 세션을 공유 데이터베이스에 저장(PersistenceManager + JDBCStore)
3. 메모리 내 복제 사용, Tomcat과 함께 제공되는 SimpleTcpCluster 사용(lib/catalina-tribes.jar + lib/catalina-ha.jar)

Tomcat은 DeltaManager를 사용하여 세션 상태의 all-to-all replication를 수행하거나 BackupManager를 사용하여 하나의 노드에만 백업 복제를 수행할 수 있습니다. all-to-all replication은 **클러스터가 작을 때만 효율적인 알고리즘**입니다. 대규모 클러스터의 경우 BackupManager를 사용하여 세션이 하나의 백업 노드에만 저장되는 primary-secondary session replication 전략을 사용해야 합니다.
현재 도메인 작업자 속성(mod_jk > 1.2.8)을 사용하여 DeltaManager를 통해 보다 확장 가능한 클러스터 솔루션을 가질 가능성이 있는 클러스터 파티션을 구축할 수 있습니다(이를 위해서는 도메인 인터셉터를 구성해야 합니다). 전체 환경에서 네트워크 트래픽을 낮게 유지하려면 클러스터를 더 작은 그룹으로 분할할 수 있습니다. 이는 서로 다른 그룹에 대해 서로 다른 멀티캐스트 주소를 사용하여 쉽게 달성할 수 있습니다. 매우 간단한 설정은 다음과 같습니다.   
![image](https://github.com/user-attachments/assets/bfd6c2f3-c2c5-4a5e-9847-1706988c4589)

여기서 중요한 점은 session replication는 클러스터링의 시작일 뿐이라는 점입니다. 클러스터를 구현하는 데 사용되는 또 다른 인기 있는 개념은 farming입니다. 즉, 하나의 서버에만 앱을 배포하고 클러스터는 전체 클러스터에 배포를 배포합니다. 이는 FarmWarDeployer(s. server.xml의 클러스터 예제)에 들어갈 수 있는 모든 기능입니다.
