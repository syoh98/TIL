## 🔍 Disk vs In-memory
### ⏺️ Disk 기반 DB
* 장점
  * 디스크 가격이 메모리 가격보다 저렴하기 때문에 데이터를 상대적으로 저렴하게 저장할 수 있다.
* 단점
  * 메모리에서 데이터를 가져오는 것보다 디스크에서 데이터를 가져오는 것이 속도가 느리다.
### ⏺️ In-memory DB
* 장점
  * 데이터 I/O시 메모리와 디스크 간 병목이 없기 때문에 Disk 기반 DB보다 속도가 빠르다.
* 단점
  * 영속성을 보장하지 않는다(= 서버가 다운되거나 동작 과정 중 데이터가 유실될 수 있다.)
  * 메모리에 데이터를 저장하기 때문에 저장 공간이 한정되어 있다.
</br>

## 🤔 In-memory DB에는 어떤 종류가 있을까?
### ⏺️ Memcached
* 데이터 타입
  * 데이터를 문자열(String)로만 저장한다. (`JSON.stringify()` 등의 메서드를 통해 데이터를 전부 변환하여 저장하고, 가져올 때도 파싱을 해야한다.)
* 데이터 지속성
  * In-memory DB의 특징인 영속성을 보장하지 않는 점 때문에 데이터 유실의 위험이 있다.
* 성능
  * `Write`의 경우 Memcached의 속도가 더 빠르다.   
    <img src="https://github.com/syoh98/TIL/assets/76934280/29334493-9198-44ea-942d-979607f1877a" width="500"/></br>

### ⏺️ Redis
* 데이터 타입
  * Memcached보다 다양한 자료형을 지원한다. 때문에 변환과 파싱없이 원하는 데이터를 바로 다룰 수 있다.   
    <img src="https://github.com/syoh98/TIL/assets/76934280/0df39410-1510-4db8-87c2-a8f4e35db307" width="500"/></br>
* 데이터 지속성
  * Master-Slave 방식의 Replication(복제)을 지원하기 때문에 Master 노드에서 장애가 발생하면 Master 노드에 있는 데이터를 Slave 노드에게 복제하여 Slave 노드가 Master 노드가 되어 서비스를 이어갈 수 있다.
    또한, AOF(Append Only File) LOG와 RDB(Redis Database Backup File) Snapshot을 통해 In-memory에 저장된 데이터를 Disk에 백업할 수 있다.
* 성능
  * `Read`의 경우 Redis가 더 빠르다.   
    <img src="https://github.com/syoh98/TIL/assets/76934280/5f162253-1d08-4eeb-a815-a08d4e734999" width="500"/></br>
</br>

* 참고
  * https://aws.amazon.com/ko/elasticache/redis-vs-memcached/
  * https://www.instaclustr.com/blog/redis-vs-memcached/
  * https://velog.io/@sjhello/세션-스토리지로-어떤-것을-사용할-수-있을까
  * https://www.sciencedirect.com/science/article/pii/S1319157816300453?via%3Dihub#t0015
