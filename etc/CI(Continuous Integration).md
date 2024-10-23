# CI(Continuous Integration, 지속적 통합)란?

CI는 개발자를 위한 `자동화 프로세스`를 의미한다.

CI를 성공적으로 구현할 경우 애플리케이션에 대한 새로운 코드 변경 사항이 정기적으로 빌드 및 테스트되어 공유 리포지토리에 통합되므로 **여러 명의 개발자가 동시에 애플리케이션 개발과 관련된 코드 작업을 할 경우 서로 충돌할 수 있는 문제를 해결**할 수 있다.   
</br>
# CI 구현 기술

## Jenkins

- 장점
    - 오픈소스로 자유롭게 사용이 가능하다.
    - 1,800개 이상의 플러그인을 지원하여 다른 툴 및 환경과 쉽게 통합할 수 있다. (ex. Git, Docker, Kubernetes, Maven, Gradle)
    - 프로젝트의 규모, 요구사항에 맞게 파이프라인을 원하는 대로 설계하고 확장할 수 있다.
    - 분산 빌드 시스템을 통해 여러 노드에서 빌드를 병렬로 실행하면 성능을 높일 수 있어 대규모 프로젝트에 효과적으로 사용할 수 있다.
    - Linux, Windows, macOS 등 여러 운영체제에서 실행될 수 있어 다양한 환경에 적용이 가능하다.
    - 공식문서와 같은 참고 자료가 다양하다.
- 단점
    - 초기 설정이 복잡하다. 필요한 플러그인을 찾고 설정하는 데 많은 시간이 든다.   

## GitLab CI

- 장점
    - GitLab은 소프트웨어 생명 주기 전반을 관리하는 플랫폼이기에 소스 코드와 CI/CD 파이프라인을 한 곳에서 관리할 수 있다. (불필요한 설정이나 화면 전환 없이 빠르고 효율적으로 파이프라인을 통합하고 실행할 수 있다.)
- 단점
    - private 저장소에서 고급 기능을 사용하려면 유료 플랜을 구독해야 한다. 프로젝트가 커지면 비용이 증가할 수 있다.

## Circle CI

- 장점
    - 클라우드 기반으로 빌드 속도가 빠르다.
    - 여러 job을 병렬로 실행시킬 수 있으며, 빌드를 위해 가상 서버를 띄워서 사용하기 때문에 여러 Job을 동시에 실행해도 충돌이 나지 않는다.
- 단점
    - 빌드 실행 시간에 따라 요금이 부과되기 때문에 대규모 프로젝트에서는 비용이 빠르게 증가할 수 있다.

## GitHub Actions

- 장점
    - code push, pull request, 이슈 생성 등 GitHub에서 발생하는 모든 이벤트에 대해 자동으로 CI/CD 파이프 라인을 트리거 할 수 있다.
    - public 리포지토리에서 무료로 무제한으로 사용 가능하다. private 리포지토리에서도 무료 플랜을 제공한다.
- 단점
    - GitHub 리포지토리에 의존적이기 때문에 다른 플랫폼을 사용하는 경우 제한이 있다.   
</br>

# 정리

|  | **Jenkins** | GitLab CI | Circle CI | GitHub Actions |
| --- | --- | --- | --- | --- |
| 오픈소스 | O | O | X | X |
| 비용 | Free | $4/month (free for public repos) | $39/month | Free (Limited on private repos) |
| 지원 OS | Windows, Linux, macOS, Unix-like OS | Linux distributions (Ubuntu, Debian, CentOS, etc.) | Linux, macOS | Windows, Linux, macOS |
| 호스팅 | On premise & Cloud | On premise & Cloud | On premise & Cloud | Cloud only |
| 통합 & 플러그인 | 1800+ Plugins | Built-in integrations (e.g., Jira) | 150 Integrations | GitHub Marketplace |
| 지원되는 Git 저장 | Any Git repository | Any Git repository | GitHub, GitLab, BitBucket | GitHub only |
