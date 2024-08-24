https://docs.oracle.com/javase/8/docs/api/java/sql/Timestamp.html

JDBC API가 SQL TIMESTAMP 값으로 식별할 수 있도록 하는 `java.util.Date` wrapper이다. 소수 초를 나노초 정밀도까지 지정할 수 있도록 하여 SQL TIMESTAMP 소수 초 값을 보유하는 기능을 추가한다. 타임스탬프는 타임스탬프 값에 대한 JDBC 이스케이프 구문을 지원하기 위한 형식 지정 및 구문 분석 작업도 제공한다.

Timestamp 객체의 정밀도는 다음 중 하나로 계산된다.

- 19 - yyyy-mm-dd hh:mm:ss의 문자 수
- 20 + s는 yyyy-mm-dd hh:mm:ss.[fff...]의 문자 수이며 s는 주어진 타임스탬프의 소수 자릿수 초 정밀도를 나타낸다.

*Note*: 이 유형은 **java.util.Date**와 별도의 나노초 값을 조합한 것이다. **java.util.Date** 구성 요소에는 정수 초만 저장된다. 분수 초(나노)는 별개이다. 날짜의 나노 구성 요소를 알 수 없기 때문에 Timestamp.equals(Object) 메서드는 java.sql.Timestamp의 인스턴스가 아닌 개체를 전달하는 경우 true를 반환하지 않는다. 결과적으로 Timestamp.equals(Object) 메소드는 java.util.Date.equals(Object) 메소드에 대해 대칭이 아니다. 또한 hashCode 메소드는 기본 java.util.Date 구현을 사용하므로 계산에 나노를 포함하지 않는다.

위에서 언급한 Timestamp 클래스와 java.util.Date 클래스 간의 차이점으로 인해 코드에서 Timestamp 값을 일반적으로 java.util.Date의 인스턴스로 보지 않는 것이 좋다. Timestamp와 java.util.Date 간의 상속 관계는 실제로 유형 상속이 아닌 구현 상속을 나타낸다.
