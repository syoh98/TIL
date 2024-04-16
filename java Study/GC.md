## 🗑️ GC(Garbage Collection)

### 🗑️ GC(Garbage Collection)란?   
동적으로 할당된 메모리 영역 중 어떤 변수도 가리키지 않는 메모리 영역(Heap)을 탐지하여 자동으로 해제하는 메모리 관리 기법이다.
</br>

### 🤔 GC는 왜 필요할까?
* C에서 메모리를 동적으로 할당받는 경우
```c
char *s = malloc(sizeof(char)*10);
s = "Garbage Collection";
printf("%s", s);

free(s); // 메모리 해제
```
메모리를 관리하기 위해 코드 레벨에서 동적으로 할당받고 해제해야한다.
  * 이렇게 메모리를 수동으로 관리하는 것은 번거롭다.
  * 또한 할당받은 메모리 영역을 제대로 해제하지 않았을 경우 `Memory Leak`이 발생할 수도 있다.
* 💡 JAVA에서는 동적메모리 영역 해제를 GC가 알아서 해준다. 즉, **수동으로 메모리를 관리할 때 발생하는 에러들을 방지할 수 있다**
  * 개발자의 실수로 인한 Memory Leak 방지
  * 해제된 메모리에 접근하는 것 방지
  * 해제한 메모리를 또 해제하는 것 방지
</br>

### 🤔 해제할 동적 메모리 영역이 무엇인지 어떻게 판단할까?
**GC를 구현한 알고리즘(java/javascript), Mark And Sweep**
![image](https://github.com/syoh98/TIL/assets/76934280/548525e9-3ffa-445f-a273-115652ce3325)
Root set은
* JVM 메모리의 Stack 로컬 변수에 대한 참조
* Method Area에 저장된 static 변수에 대한 참조
* 네이티브 스택, 즉 JNI(Java Native Interface)에 의해 생성된 객체에 대한 참조   
로, Root set으로부터 Heap 영역의 객체에 접근 가능하면 `Reachable`, 접근 불가능하면 `Unreachable`이라고 표현한다.   
이 `Unreachable`한 객체를 Heap 영역에서 제거해주는 것이다.    
즉, 해제할 동적 메모리 영역은 `Unreachable`한 객체인 것이다.
</br>

### 🤔 GC는 어떻게 동작할까?(JVM의 Heap 영역)
![image](https://github.com/syoh98/TIL/assets/76934280/8a2326c8-a2b2-418b-ae30-a10de7310cae)
JVM에서 Heap 영역은 Young generation, Old generation으로 나뉜다.   
Young generation에서 발생하는 GC는 minor gc, Old generation에서 발생하는 GC는 major gc이다.   
Young generation은   
* Eden
* Survival 0
* Survival 1으로 나뉜다.
Eden은 새롭게 생성된 객체들이 할당되는 영역이고, Survival 영역은 `minor gc`로 부터 살아남은 객체들이 존재하는 영역이다. Survival 0,1에 둘 중 하나는 꼭 비어 있어야 하는 규칙이 존재한다.   
또한, `minor gc`로 부터 살아남을 때마다 `age-bit`가 1씩 증가하는데,  JVM GC에서는 일정 수준의 `age-bit`를 넘어가면 오래도록 참조될 객체라고 판단하여 해당 객체를 Old Generation에 넘겨주며, 이 과정을 Promotion이라고 한다.   
java 8에서는 Parallel GC 방식 사용 기준 `age-bit`가 15가 되면 promotion이 진행된다.   
만약 Old generation이 다 채워지면 major GC가 발생하면서 Mark and Sweep 방식을 통해 필요없는 메모리를 비워준다. `major GC`는 `minor GC`보다 더 오래걸린다.
</br>

### 🤔 그럼 왜 Heap 메모리 구조를 나누어(Young generation/Old generation) 관리할까?
GC 설계자들이 어플리케이션을 분석했을 때 대부분의 할당된 객체가 수명이 짧아 금방 GC의 대상이 되었다. 따라서 **메모리의 특정 부분만 GC를 수행하여 GC 비용을 줄인다.**
