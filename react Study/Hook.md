## 🌐 Hook이란?
함수형 컴포넌트에서 **상태(state)** 와 **생명주기 기능(lifecycle features)** 을 연동할 수 있게 해주는 함수이다.
</br></br>

## 🌐 Hook을 사용하는 이유는 뭘까?

### 클래스형 컴포넌트
```jsx
import React, { Component } from "react";

class Counter extends Component {
  constructor(props) {
    super(props);
    this.state = { count: 0 }; // 초기 state 설정
  }

  // 버튼 클릭 시 실행될 메서드
  handleIncrease = () => {
    this.setState({ count: this.state.count + 1 });
  };

  handleDecrease = () => {
    this.setState({ count: this.state.count - 1 });
  };

  // 컴포넌트가 마운트될 때 실행
  componentDidMount() {
    console.log("Counter component mount");
  }

  // 컴포넌트가 업데이트될 때 실행
  componentDidUpdate() {
    console.log("Counter update, current count:", this.state.count);
  }

  // 컴포넌트가 언마운트될 때 실행
  componentWillUnmount() {
    console.log("Counter component unmount");
  }

  render() {
    return (
      <div>
        <h1>클래스형 컴포넌트</h1>
        <h2>Count: {this.state.count}</h2>
        <button onClick={this.handleIncrease}>+</button>
        <button onClick={this.handleDecrease}>-</button>
      </div>
    );
  }
}

export default Counter;
```
ES6의 class 문법을 사용한 리액트 컴포넌트로, 상태를 직접 관리할 수 있고 생명주기 메서드를 사용할 수 있다.
* `this.state`, `this.setState()` 사용 -> 상태 관리의 번거로움
* `this.handleIncrease = this.handleIncrease.bind(this);` -> 이벤트 핸들링 시 `this` 바인딩 필요
* `componentDidMount`, `componentDidUpdate`, `componentWillUnmount`... 따로 사용 -> 생명주기 관리의 어려움 </br>
**➡️ 이러한 점을 개선한 Hook이 React 16.8 부터 도입되었다.**
</br>

### 클래스 컴포넌트 vs 함수형 컴포넌트(Hook)
```jsx
import React, { useState, useEffect } from "react";

const Counter = () => {
  const [count, setCount] = useState(0); // 상태 관리 간결

  useEffect(() => {
    console.log("mount");

    return () => {
      console.log("unmount"); // 언마운트 시점도 함께 관리 가능
    };
  }, []); // 빈 배열([]) → 마운트 시 1번만 실행

  useEffect(() => {
    console.log(`Counter update, current count: ${count}`);
  }, [count]); // count 값이 변경될 때만 실행

  return (
    <div>
      <h1>함수형 컴포넌트</h1>
      <h2>Count: {count}</h2>
      <button onClick={() => setCount(count + 1)}>+</button> {/* this 바인딩 문제 해결 */}
    </div>
  );
};

export default Counter;
```
* `useState`로 상태 관리 -> `this.state`, `this.setState()` 필요 X
* `this` 바인딩 없이 이벤트 핸들링 가능 -> `this.handleIncrease.bind(this)` 필요 X
* `useEffect` 하나로 생명주기 관리 가능 -> `componentDidMount`, `componentDidUpdate`, `componentWillUnmount`... 통합

## 🌐 모든 훅 파헤치기
* **useState**
  * 함수 컴포넌트 내부에서 상태를 정의하고, 이 상태를 관리할 수 있게 해주는 훅이다.
  * ```jsx
    import { useStatus } from 'react'
    const [state, setStatus] = useStatus(initialState)
    ```
  * useState 훅의 반환 값은 배열이며, 배열의 첫 번째 원소로 state 값 자체를 사용할 수 있고 두 번째 원소인 setState 함수를 사용해 해당 state의 값을 변경할 수 있다.
* **useEffect**
  * 애플리케이션 내 컴포넌트의 여러 값들을 활용해 동기적으로 부수 효과를 만드는 매커니즘이다.
    * ```jsx
      function Component() {
        useEffect(() => {
        // ...
        }, [props, state])
      }
      ``` 
    * 두 개의 인수를 받는데, 첫 번째는 콜백, 두 번째는 의존성 배열이다. 이 두 번째 의존성 배열의 값이 변경되면 첫 번째 인수인 콜백을 실행한다.
    * 클래스 컴포넌트의 생명주기 메서드와 비슷한 작동을 구현할 수 있다. 두 번째 의존성 배열에 빈 배열을 넣으면 컴포넌트가 마운트될 때만 실행된다.
    * useEffect는 클린업 함수를 반환할 수 있는데, 이 클린업 함수는 컴포넌트가 언마운트될 때 실행된다.
* **useMemo**
  * ```jsx
    import {useMemo} from 'react'
    const memoizedValue = useMemo(() => expensiveComputation(a, b), [a, b])
    ```
  * 비용이 큰 연산에 대한 결과를 저장(메모이제이션)해 두고, 이 저장된 값을 반환하는 훅이다.
* **useCallback**
  * useMemo는 값을 기억하는 반면 useCallback은 인수로 넘겨받은 콜백 자체를 기억한다. 쉽게 말해 useCallback은 특정 함수를 새로 만들지 않고 다시 재사용한다.
* **useRef**
  * useState와 동일하게 컴포넌트 내부에서 렌더링이 일어나도 변경 가능한 상태값을 저장한다.
  * useState와의 차이점
    * useRef는 반환값인 객체 내부에 있는 current로 값에 접근 또는 변경할 수 있다.
    * useRef는 그 값이 변하더라도 렌더링을 발생시키지 않는다.
* **useContext**
  * Context API를 사용하여 전역 상태를 쉽게 가져올 수 있도록 도와주는 기능이다.
* **useReducer**
  * useState와 비슷한 형태를 띠지만 좀 더 복잡한 상태값을 미리 정의해 놓은 시나리오에 따라 관리할 수 있다.
* **useImperativeHandle**
  * React의 ref를 커스텀하여 특정 메서드나 속성만 외부에서 접근 가능하도록 제한하는 훅이다.
* **useLayoutEffect**
  * useEffect와 동일하나, 모든 DOM의 변경 후에 동기적으로 발생한다.
* **useDebugValue**
  * 리액트 애플리케이션을 개발하는 과정에서 사용되는데, 디버깅하고 싶은 정보를 이 훅에다 사용하면 리액트 개발자 도구에서 볼 수 있다.
 
## 🌐 공식문서
https://ko.legacy.reactjs.org/docs/hooks-intro.html
