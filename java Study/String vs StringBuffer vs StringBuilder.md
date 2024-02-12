<h2>✏️ String vs StringBuffer vs StringBuilder </h2>
<h3>📌 String</h3>
변경 불가능한<b>(immutable)</b>클래스, String 객체가 생성되면 그 값은 변하지 않는다.</br>
문자열 추가와 변경이 발생하지 않는 경우 사용한다.</br></br>
<b>문자열 생성 2가지 방법</b></br>

* 문자열 리터럴 지정(이미 존재하는 것 재사용) </br>

```java
String str1 = "abc";
String str2 = "abc";
```
<img src="https://github.com/syoh98/TIL/assets/76934280/78ce4f68-d2d6-4451-b7a8-951a2b3d8df1" width="400"/> </br>

* String클래스 생성자 사용(new 연산자에 의해 메모리 할당, 항상 새로운 String 인스턴스 생성) </br>

```java
String str3 = new String("abc");
String str4 = new String("abc");

```

<img src="https://github.com/syoh98/TIL/assets/76934280/5fb7d58d-b6d7-4f01-9835-ff3f018761dc" width="400"/> </br>

<h3>📌 StringBuffer</h3>
기존의 객체로 문자열 추가와 변경이 가능<b>(mutable)</b>한 클래스</br>
반환타입이 StringBuffer로 자신의 주소를 반환한다.</br>
<b>멀티쓰레드 환경</b>에서 문자열 추가와 변경이 발생하는 경우 사용한다.</br>

* String클래스는 equals메서드를 오버라이딩해서 문자열의 내용을 비교하도록 구현되어있지만, StringBuffer클래스는 equals메서드를 오버라이딩 하지않는다.(toString()은 오버라이딩 되어있다)</br>

```java
class StringBufferEx1 {
    public static void main(String[] args) {
        StrinBuffer sb = new StringBuffer("abc");
        StrinBuffer sb2 = new StringBuffer("abc");

        System.out.println("sb == sb2 ?" + (sb == sb2)); // false
        System.out.println("sb.equals(sb2) ? " + sb.equals(sb2)); // false

        String s = sb.toString();
        String s2 = sb2.toString();
    
        System.out.println("s.equals(s2) ? " + s.equals(s2)); // true
    }
}

```

<h3>📌 StringBuilder</h3>
기존의 객체로 문자열 추가와 변경이 가능<b>(mutable)</b>한 클래스</br>
멀티쓰레드에 안전하도록 동기화 되어있다.</br>
<b>단일쓰레드 환경</b>에서 문자열 추가와 변경이 발생하는 경우 사용한다.</br>
