<h2>✏️ this vs this() </h2>
<h3>* this: 인스턴스 자신을 가리키는 참조변수</h3>

```java
Car(String color, String gearType, int door) {
    // 인스턴스 변수와 매개변수를 구분
    this.color = color;
    this.gearType = gearType;
    this.door = door;
}
```
</br>
<h3>* this(): 생성자 안에서 다른 생성자를 호출하기 위해 사용</h3>

```java
public MemberConstruct(String name, int age) {
    this.name = name;
    this.age = age;
    this.grade = 50;
}

public MemberConstruct(String name, int age, int grade) {
    this.name = name;
    this.age = age;
    this.grade = grade;
}
```
name과 age의 코드가 중복된다.</br>

```java
public class MemberConstruct {
    String name;
    int age;
    int grade;

    MemberConstruct(String name, int age) {
        this(name, age, 50); // 변경
    }

    MemberConstruct(String name, int age, int grade) {
        System.out.println("생성자 호출 name=" + name + ", age=" + age + ", grade=" + grade);
        this.name = name;
        this.age = age;
        this.grade = grade;
    }
}
```
this()를 사용하여 생성자 내부에서 다른 생성자를 호출할 수 있다(중복제거)</br>

<b>📌 this는 참조변수이고, this()는 생성자이다</b>
