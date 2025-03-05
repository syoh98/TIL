[Reacting to Input with State](https://react.dev/learn/reacting-to-input-with-state)</br>

리액트는 UI를 조작하는 선언적인 방식을 제공합니다. 개별 UI 요소를 직접 조작하는 대신 컴포넌트가 가질 수 있는 다양한 상태를 정의하고 **사용자 입력에 따라 이 상태를 전환**합니다. 이는 디자이너가 UI를 설계하는 방식과 유사합니다.

## 선언형(Declarative) UI vs 명령형(Imperative) UI 비교
UI 상호작용을 설계할 때, 아마도 사용자 행동에 따라 UI가 어떻게 변하는 지를 생각할 것입니다. 예를 들어, 사용자가 답변을 제출할 수 있는 폼을 고려해 봅시다.

- 폼에 무언가를 입력하면 "제출(Submit)" 버튼이 활성화됩니다.
- "제출" 버튼을 누르면 폼과 버튼이 비활성화되고, 로딩 스피너가 나타납니다.
- 네트워크 요청이 성공하면 폼이 숨겨지고 "감사합니다(Thank you)" 메시지가 표시됩니다.
- 네트워크 요청이 실패하면 오류 메시지가 표시되며, 폼이 다시 활성화됩니다.

명령형 프로그래밍에서는 위의 동작을 직접 구현하는 방식과 일치합니다. 발생한 이벤트에 따라 UI를 조작하는 정확한 명령을 작성해야 합니다.

이를 다른 방식으로 생각해보면, 마치 자동차를 타고 옆에 앉아 운전자에게 "여기서 좌회전하세요, 다음 신호에서 우회전하세요"라고 한 단계씩 지시하는 것과 같습니다.</br>
![image](https://github.com/user-attachments/assets/dd156eaf-7cd5-43b5-8f9f-bbfe3bd39055)</br>
운전자는 당신이 가고 싶은 목적지를 알지 못하고, 그저 명령을 따라갑니다. (그리고 만약 방향을 잘못 알려주면 엉뚱한 곳에 도착하게 됩니다!)
이것이 "**명령형(Imperative)**"이라고 불리는 이유입니다. 스피너부터 버튼까지 각 요소에 대해 명확한 명령을 내리고, 컴퓨터에게 UI를 어떻게 업데이트할지 직접 지시해야 합니다.</br>
이 명령형 UI 프로그래밍 예제에서는 React 없이 폼을 구성합니다. 오직 브라우저의 DOM만을 사용합니다.

**명령형 방식으로 UI를 조작하는 것은 간단한 예제에서는 충분히 효과적이지만, 시스템이 복잡해질수록 관리가 기하급수적으로 어려워집니다.** 예를 들어, 여러 개의 폼이 있는 페이지에서 각 폼을 명령형 방식으로 업데이트해야 한다고 상상해 보세요. 새로운 UI 요소나 인터랙션을 추가할 때마다 기존 코드를 면밀히 검토해야 하며, 실수로 요소를 숨기거나 표시하는 것을 잊어버릴 가능성이 높아집니다.

**React는 이러한 문제를 해결하기 위해 만들어졌습니다.**

React에서는 UI를 직접 조작하지 않습니다. 즉, 컴포넌트를 직접 활성화하거나 비활성화하고, 표시하거나 숨기지 않습니다. 대신, 어떤 UI를 보여줄지 선언하면 React가 UI를 업데이트하는 방법을 알아서 결정합니다. 이는 마치 **택시에 타서 운전사에게 목적지를 말하는 것과 같습니다**. 운전사가 어떻게 갈지 고민할 필요 없이, 목적지만 말하면 되고, 때로는 운전사가 우리가 생각하지 못한 지름길을 알고 있을 수도 있습니다.</br>
![image](https://github.com/user-attachments/assets/a18b180f-30f6-4743-8bad-c46b5b95a7c9)</br>

## UI를 선언적으로 생각하기

위에서 폼을 명령형 방식으로 구현하는 방법을 살펴보았습니다. 이제 React에서의 사고 방식을 더 잘 이해하기 위해, 동일한 UI를 React로 다시 구현하는 과정을 살펴보겠습니다.

1. 컴포넌트의 다양한 시각적 상태 식별하기
2. 이 상태 변화가 발생하는 트리거 식별하기
3. useState를 사용하여 상태를 메모리에 저장하기
4. 불필요한 상태 변수를 제거하기
5. 이벤트 핸들러를 상태 변경 함수에 연결하기

### 1단계: 컴포넌트의 다양한 시각적 상태 식별하기

컴퓨터 과학에서는 "상태 머신(State Machine)"이 여러 개의 "상태(States)" 중 하나에 있을 수 있다고 합니다. 디자이너와 협업할 경우 서로 다른 "시각적 상태(Visual States)"를 나타내는 목업(Mockups)을 본 적이 있을 수도 있습니다.

React는 **디자인과 컴퓨터 과학의 교차점**에 위치하기 때문에 이러한 개념들이 React의 동작 방식에 영감을 줍니다.

먼저, 사용자가 UI에서 경험할 수 있는 모든 "**상태(States)**"를 **시각적으로 정리**해 봅시다:

- **Empty (초기 상태):** 폼의 "제출(Submit)" 버튼이 비활성화됨
- **Typing (입력 중 상태):** 사용자가 입력을 시작하면 "제출" 버튼이 활성화됨
- **Submitting (제출 중 상태):** 폼이 완전히 비활성화됨. 로딩 스피너(Spinner)가 표시됨
- **Success (성공 상태):** 폼이 사라지고 "감사합니다(Thank you)" 메시지가 표시됨
- **Error (실패 상태):** 입력 중 상태(Typing)와 동일하지만 추가적으로 오류 메시지가 표시됨

디자이너가 UI의 다양한 상태를 설계하듯이, 개발자도 **"목업(Mockup)"** 또는 **"목(Mocks)"** 을 만들어 각 상태를 **논리 없이 시각적으로 표현하는 것이 중요**합니다.

예를 들어, 아래는 단순히 **시각적 요소만 구현한 폼의 목업**입니다.

이 목업은 `status`라는 **prop**에 의해 상태가 결정되며, 기본값(default value)은 `'empty'`로 설정됩니다.
```javascript
export default function Form({
  status = 'empty'
}) {
  if (status === 'success') {
    return <h1>That's right!</h1>
  }
  return (
    <>
      <h2>City quiz</h2>
      <p>
        In which city is there a billboard that turns air into drinkable water?
      </p>
      <form>
        <textarea />
        <br />
        <button>
          Submit
        </button>
      </form>
    </>
  )
}
```
이 `prop`의 이름은 자유롭게 정할 수 있으며, 중요한 것은 아닙니다.

예를 들어, `status = 'empty'`를 `status = 'success'`로 변경하면 **성공 메시지**가 나타나는 것을 확인할 수 있습니다.

**목업(Mocking)** 을 사용하면 로직을 연결하기 전에 UI를 빠르게 반복 수정(Iterate)할 수 있습니다.

아래는 같은 컴포넌트를 보다 구체적으로 구현한 **프로토타입(Prototype)** 으로, 여전히 `status` **prop**에 의해 제어됩니다.
```javascript
export default function Form({
  // Try 'submitting', 'error', 'success':
  status = 'empty'
}) {
  if (status === 'success') {
    return <h1>That's right!</h1>
  }
  return (
    <>
      <h2>City quiz</h2>
      <p>
        In which city is there a billboard that turns air into drinkable water?
      </p>
      <form>
        <textarea disabled={
          status === 'submitting'
        } />
        <br />
        <button disabled={
          status === 'empty' ||
          status === 'submitting'
        }>
          Submit
        </button>
        {status === 'error' &&
          <p className="Error">
            Good guess but a wrong answer. Try again!
          </p>
        }
      </form>
      </>
  );
}
```
### 2단계: 상태 변경을 유발하는 트리거 식별하기

상태 업데이트는 두 가지 유형의 입력에 의해 트리거될 수 있습니다:

1. **사용자 입력 (Human Inputs):** 버튼 클릭, 입력 필드에 타이핑, 링크 탐색
2. **컴퓨터 입력 (Computer Inputs):** 네트워크 응답 도착, 타이머 완료, 이미지 로드 완료</br>
![image](https://github.com/user-attachments/assets/f03ca3ee-ce5b-4f37-93c8-a30efb4e149c)</br>

두 경우 모두 UI를 업데이트하려면 상태 변수를 설정해야 합니다.

개발 중인 폼에서는 여러 입력에 따라 상태를 변경해야 합니다:

- **텍스트 입력 변경**(사용자 입력)은 입력란이 비어 있는지 여부에 따라 Empty 상태에서 Typing 상태로 전환하거나 다시 돌아가야 합니다.
- **"제출(Submit)" 버튼 클릭**(사용자 입력)은 Submitting 상태로 전환해야 합니다.
- **네트워크 응답 성공**(컴퓨터 입력)은 Success 상태로 전환해야 합니다.
- **네트워크 응답 실패**(컴퓨터 입력)는 Error 상태로 전환하고, 해당 오류 메시지를 표시해야 합니다.

이 흐름을 시각적으로 이해하기 위해, 각 상태를 레이블이 있는 원(circle)으로 그리고, 상태 간 전환을 화살표(arrow)로 나타내 보세요.

이런 방식으로 여러 흐름을 스케치하면, 구현 전에 미리 버그를 찾아낼 수 있습니다.</br>
![image](https://github.com/user-attachments/assets/5b2b534e-2032-4481-bb84-97b52659cf96)</br>

### 3단계: useState를 사용하여 상태를 메모리에 저장하기
다음으로, `useState`를 사용하여 **컴포넌트의 시각적 상태를 메모리에 저장**해야 합니다.

단순함이 핵심입니다. **상태는 "변화하는 요소"이므로**, **가능한 한 적은 상태만 유지하는 것이 중요**합니다.

복잡성이 증가할수록 버그도 많아집니다! 우선 반드시 필요한 상태부터 시작하세요.

예를 들어, 입력된 답변을 저장해야 하며, 오류가 발생한 경우 마지막 오류 메시지를 저장해야 합니다:
```javascript
const [answer, setAnswer] = useState('');
const [error, setError] = useState(null);
```
```javascript
const [isEmpty, setIsEmpty] = useState(true);
const [isTyping, setIsTyping] = useState(false);
const [isSubmitting, setIsSubmitting] = useState(false);
const [isSuccess, setIsSuccess] = useState(false);
const [isError, setIsError] = useState(false);
```
처음 떠오른 아이디어가 최선이 아닐 수도 있지만, 괜찮습니다—상태를 리팩터링하는 과정도 개발의 일부입니다!

### 4단계: 필수적이지 않은 상태 변수 제거

상태에서 중복을 피하고 오직 필수적인 정보만 추적해야 합니다.

상태 구조를 리팩터링하는 데 시간을 투자하면, **컴포넌트를 더 이해하기 쉽게 만들고 중복을 줄이며 의도하지 않은 의미를 방지**할 수 있습니다.

목표는 **메모리에 저장된 상태가 항상 유효한 UI를 나타내도록 하는 것**입니다.

(예를 들어, 오류 메시지를 표시하면서 입력 필드를 동시에 비활성화하면, 사용자가 오류를 수정할 수 없게 됩니다!)

다음은 상태 변수에 대해 스스로에게 던질 수 있는 몇 가지 질문입니다:

- **이 상태가 모순을 일으키는가?**
    - 예를 들어, `isTyping`과 `isSubmitting`이 동시에 `true`가 될 수는 없습니다. 모순이 발생한다면 상태가 충분히 제한되지 않은 것입니다. 두 개의 booleans 값에는 네 가지 가능한 조합이 있지만 그중 세 가지만 유효한 상태를 나타냅니다. 이러한 "불가능한" 상태를 제거하려면, `status` 변수를 사용하여 `'typing'`, `'submitting'`, 또는 `'success'` 중 하나의 값만 가질 수 있도록 만들 수 있습니다.
- **다른 상태 변수에서 이미 같은 정보를 제공하는가?**
    - 또 다른 모순: `isEmpty`와 `isTyping`이 동시에 `true`가 될 수 없습니다. 이들을 별도의 상태 변수로 관리하면 동기화가 어긋나 버그가 발생할 위험이 있습니다. 다행히 `isEmpty`를 제거하고 대신 `answer.length === 0`을 확인하면 됩니다.
- **다른 상태 변수의 반대 값으로 같은 정보를 얻을 수 있는가?**
    - `isError` 상태 변수는 필요하지 않습니다. 대신 `error !== null`을 확인하면 충분합니다.

이러한 정리를 거치면, 기존 7개의 상태 변수에서 3개의 필수적인 상태 변수만 남게 됩니다!
```javascript
const [answer, setAnswer] = useState('');
const [error, setError] = useState(null);
const [status, setStatus] = useState('typing'); // 'typing', 'submitting', or 'success'
```
기능을 손상시키지 않고는 어떤 것도 제거할 수 없기 때문에 이것이 필수적이라는 것을 알고 있습니다.

### 5단계: 이벤트 핸들러를 연결하여 상태 설정

마지막으로 상태를 업데이트하는 이벤트 핸들러를 만듭니다. 다음은 모든 이벤트 핸들러가 연결된 최종 양식입니다.
```javascript
import { useState } from 'react';

export default function Form() {
  const [answer, setAnswer] = useState('');
  const [error, setError] = useState(null);
  const [status, setStatus] = useState('typing');

  if (status === 'success') {
    return <h1>That's right!</h1>
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setStatus('submitting');
    try {
      await submitForm(answer);
      setStatus('success');
    } catch (err) {
      setStatus('typing');
      setError(err);
    }
  }

  function handleTextareaChange(e) {
    setAnswer(e.target.value);
  }

  return (
    <>
      <h2>City quiz</h2>
      <p>
        In which city is there a billboard that turns air into drinkable water?
      </p>
      <form onSubmit={handleSubmit}>
        <textarea
          value={answer}
          onChange={handleTextareaChange}
          disabled={status === 'submitting'}
        />
        <br />
        <button disabled={
          answer.length === 0 ||
          status === 'submitting'
        }>
          Submit
        </button>
        {error !== null &&
          <p className="Error">
            {error.message}
          </p>
        }
      </form>
    </>
  );
}

function submitForm(answer) {
  // Pretend it's hitting the network.
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      let shouldError = answer.toLowerCase() !== 'lima'
      if (shouldError) {
        reject(new Error('Good guess but a wrong answer. Try again!'));
      } else {
        resolve();
      }
    }, 1500);
  });
}
```
비록 이 코드가 원래의 명령형 예제보다 길지만 훨씬 견고(fragile하지 않음) 합니다.

모든 상호작용을 상태 변화로 표현하면 나중에 새로운 시각적 상태를 추가하더라도 기존 상태를 망가뜨리지 않고 확장할 수 있습니다.

또한, 각 상태에서 표시할 내용을 변경하더라도 **상호작용 로직 자체를 수정할 필요 없이 유지보수가 가능**해집니다.
