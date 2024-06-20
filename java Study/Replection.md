## 🔵 리플렉션이란?
**런타임**에 사용자와 운영체제 및 기타 프로그램과 상호작용 하면서 클래스와 인터페이스 등을 검사하고 조작할 수 있는 기능

### 🤔 리플렉션은 런타임에 상호작용 한다고 하는데, 어떻게 상호작용을 하는거지?
* JVM 동작방식   
  ![image](https://github.com/syoh98/TIL/assets/76934280/304fca39-19df-4bfa-8b51-3258ceebb16c)
### 🤔 그러면 Method Area에 어떻게 접근하지?
클래스!
* Class 특징
  * public 생성자가 존재하지 않는다.
  * Class 객체는 JVM에 의해 자동으로 생성된다.
* 자동으로 생성된 Class를 가져오는 방법
  * ‘클래스 타입’.class
    * final Class<MyClass> testClass1 = MyClass.class;
  * ‘인스턴스’.getClass()
    * final MyClass obj = new MyClass();
    * final Class<? extends MyClass> testClass2 = obj.getClass();
  * Class.forName(’풀 패키지 경로’)
    * final Class<?> testClass3 = Class.forName("flab.go-table.MyClass");
* Class 메서드 사용 시 주의점
  * `getMethods`: 상위 클래스와 상위 인터페이스에서 상속한 메서드를 포함하여 public인 메서드들을 모두 가져온다.
  * `getDeclaredMethods`: 접근 제어자와 관계 없이 상속한 메서드를 제외하고 직접 클래스에서 선언한 메서드들을 모두 가져온다.

### 🤔 리플렉션, 왜 사용하지?
리플렉션은 개발자가 사용한다기보다는 주로 프레임워크나 라이브러리에서 많이 사용한다.
개발자가 개발을 할 때는 객체의 타입을 모르는 경우가 거의 없지만, 프레임워크나 라이브러리에서는 사용자가 생성한 객체가 어떤 타입인지 컴파일 시점까지 알지 못한다. 따라서 이러한 문제를 동적으로 해결하기 위해 리플렉션을 사용하는 것이다!

## 🔵 리플렉션 동작 원리

## 🔵 리플렉션 사용법

## 🔵 리플렉션이 사용되는 곳

## 🔵 리플렉션 단점



참고
* https://www.youtube.com/watch?v=67YdHbPZJn4&t=639s
* https://docs.oracle.com/javase/tutorial/reflect/index.html
* https://www.youtube.com/watch?v=RZB7_6sAtC4
