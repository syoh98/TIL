## 📝 HashMap
키(key)와 값(value)의 쌍으로 데이터를 저장하는 Map을 Hash와 접목한 자료구조
<img src="https://github.com/user-attachments/assets/d4d26590-5c21-430a-b828-43837727cb4b" width="500"/></br>
* index: hash function을 통해 구한 정수 값: 들어가야 하는 데이터의 위치가 된다.
* Node: HashMap에서 사용하는 데이터의 최소 단위. HashMap은 LinkedList로 이뤄지기 때문에 다음 노드를 가리키는 Next 변수가 존재
* Bucket: Linked List로 이어진 Node의 집합
* Capacity: Bucket의 수를 의미(기본 값: 16)


## 📝 Load Factor
Load Factor는 HashMap의 현재 크기(저장된 요소 개수)를 현재 용량(capacity)로 나눈 값이다.</br>
Load Factor의 기본 값은 0.75로 설정되어 있다. 즉, HashMap의 75%가 차면 자동으로 용량이 두 배로 늘어난다.(Resizing)
* ex) capacity: 16, load factor: 0.75 -> 저장 가능한 최대 요소 수: 16 * 0.75 = 12개
  * 12개를 초과하여 13번째 요소를 추가하면 capacity가 32로 늘어나고, 다시 75%인 24개까지 저장이 가능하다.
* Load Factor를 낮게 설정할 경우(ex: 0.5) 충돌이 줄어들어 성능이 좋아지지만, 메모리 효율성이 낮아질 수 있다.
  * 테이블이 적게 채워지면(capacity의 50%까지만 사용) 데이터가 넓게 퍼지게되면 충돌 빈도가 줄어든다.
* Load Factor를 높게 설정할 경우(ex: 1.0) 메모리는 절약되지만 충돌이 많아져 성능이 저하될 수 있다.
  * 테이블이 꽉 찰 때까지(capacity의 100%) resizing을 하지 않으므로, 하나의 버킷에 더 많은 데이터가 모이게 된다.
  * 충돌이 발생할 확률이 증가하며 버킷 당 연결 리스트의 길이가 길어진다.
  * 충돌이 많아질수록 조회, 삽입, 삭제 성능이 저하된다.
