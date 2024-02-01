<h2>✏️ super vs super() </h2>
<h3>* super: 부모클래스의 멤버와 자식클래스의 멤버가 중복 정의 되어 구별하는 경우 사용하는 참조변수</h3>

```java
Class SuperTest {
    public static void main(String[] args) {
        Child c = new Child();
        c.method();
    }

    Class Parent {
        int x = 10;
    }

    Class Child extends Parent {
        int x = 20;

        void method() {
            System.out.println("x=" + x);
            System.out.println("this.x=" + this.x);
            System.out.println("super.x=" + super.x);
        }
    } 
}
```

<b>[실행결과]</b></br>
x=20</br>
this.x=20</br>
super.x=10</br>

<h3>* super(): 부모클래스의 생성자를 호출하는데 사용되는 생성자</h3>
<b>부모의 멤버와 자신의 멤버를 구별하는데 사용된다는 점을 제외하고는 super와 this는 근본적으로 같다</b>
