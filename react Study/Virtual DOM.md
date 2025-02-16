## 🧐 DOM에 대해 더 자세히 알아보자
앞서 학습한 내용에 따르면, DOM은 브라우저가 렌더링하는 핵심 부분으로 조작할 때마다 Reflow와 Repaint가 발생하여 **성능 저하가 일어날 수 있다.** </br>
그럼 이 성능 저하를 막을 수 있는 방법이 없을까? UI의 상태 변화를 효율적으로 처리하는 방법이 없을까? </br>
➡️ 이를 개선하기 위한 방법으로 **Virtual DOM**이 등장했다.

### 📌 Virtual DOM
![image](https://github.com/user-attachments/assets/146a5979-8acd-4f60-8c40-39f86049689f)
* **Virtual DOM이란?**
    * 가상으로 존재하는 DOM의 복제본으로 **메모리 상에 존재**하며, JavaScript 객체 형태로 존재한다.
    * React는 Virtual DOM을 사용한다.
        * React에서 정의한 Virtual DOM: **"Virtual DOM (VDOM)은 UI의 이상적인 또는 “가상”적인 표현을 메모리에 저장하고 ReactDOM과 같은 라이브러리에 의해 “실제” DOM과 동기화하는 프로그래밍 개념입니다."** [(React 공식문서)](https://ko.legacy.reactjs.org/docs/faq-internals.html)
* **Virtual DOM의 동작원리**</br>
  ![image](https://github.com/user-attachments/assets/c90594fb-a254-4876-9f57-3e1b13ad7e6c) </br>
  * Virtual DOM의 비교 과정에서는 **diffing 알고리즘**이 사용되며, 해당 알고리즘은 두 가상 돔 트리를 효율적으로 비교하여 어떤 요소가 변경되었는지 파악한다.
  * **diffing 알고리즘 동작 방식**
    * 이전 가상돔 트리와 새로운 가상돔 트리를 비교하고 루트 노드에서 시작해서 이전과 새로운 노드를 비교한다.
    * 두 노드가 다른 유형이면 새 노드를 생성하여 기존 노드를 대체한다.
    * but, 두 노드가 같은 유형이면 속성을 비교해서 변경된 것이 있는지 확인하고 변경된 속성이 없으면 그대로 사용, 없으면 속성을 업데이트한다.
이렇게 자식노드를 재귀적으로 비교한다.
    * ➡️ 이 과정을 **재조정(reconciliation)** 이라고 한다. 재조정을 통해 변경 사항이 파악되면, 해당 변경 사항만 실제 DOM에 반영하여 업데이트한다.
    * ➡️ 해당 방식으로 **전체 DOM 트리를 재구축하지 않고, 필요한 부분만 빠르게 업데이트** 할 수 있다.
