https://docs.oracle.com/javase/8/docs/api/java/time/package-summary.html

## **Package java.time Description**

날짜, 시간, 순간 및 기간에 대한 기본 API이다.

여기에 정의된 클래스는 순간, 기간, 날짜, 시간, 시간대 및 기간을 포함한 기본 날짜-시간 개념을 나타낸다. 이는 역산 그레고리력 규칙을 따르는 사실상 세계 달력인 ISO 달력 시스템을 기반으로 한다. **모든 클래스는 변경할 수 없으며 스레드로부터 안전하다.**

각 날짜 시간 인스턴스는 API를 통해 편리하게 사용할 수 있는 필드로 구성된다.

- 필드에 대한 낮은 수준의 액세스는 `java.time.temporal` 패키지를 참조하기

각 클래스에는 모든 방식의 날짜와 시간을 인쇄하고 구문 분석하는 기능이 포함되어 있다.

- 사용자 정의 옵션은 `java.time.format` 패키지를 참조하기

`java.time.chrono` 패키지에는 달력 중립 API ChronoLocalDate, ChronoLocalDateTime, ChronoZonedDateTime 및 Era가 포함되어 있다. 이는 지역화된 달력을 사용해야 하는 응용 프로그램에서 사용하기 위한 것이다. 애플리케이션은 데이터베이스나 네트워크 등 시스템 경계를 넘어 이 패키지의 ISO-8601 날짜 및 시간 클래스를 사용하는 것이 좋다. 캘린더 중립 API는 사용자와의 상호작용을 위해 예약되어야 한다.

## ***Dates and Times***

**Instant**는 기본적으로 **숫자 타임스탬프**이다. 현재 순간은 시계에서 검색이 가능하다.  특정 시점의 로깅 및 지속성에 유용하며 과거에는 `System.currentTimeMillis()`의 결과를 저장하는 것과 관련되어 있었다.

**LocalDate**는 **시간 없이 날짜를 저장**한다. **'2010-12-03'**과 같은 날짜를 저장하며 생일을 저장하는 데 사용될 수 있다.

**LocalTime**은 **날짜 없이 시간을 저장**한다. **'11:30'**과 같은 시간을 저장하며 개점 또는 폐점 시간을 저장하는 데 사용될 수 있다.

**LocalDateTime**은 **날짜와 시간을 저장**한다. **'2010-12-03T11:30'**과 같은 날짜-시간을 저장한다.

**ZonedDateTime**은 **날짜와 시간을 시간대와 함께 저장**한다. '유럽/파리'와 같은 ZoneId를 고려하여 날짜와 시간을 정확하게 계산하려는 경우에 유용하다. 시간대를 광범위하게 사용하면 애플리케이션이 상당히 복잡해지기 때문에 가능하다면 시간대 없이 간단한 클래스를 사용하는 것이 좋다.

## ***Duration and Period***

날짜와 시간 외에도 API를 사용하면 period(기간)과 duration of time(지속 시간)을 저장할 수도 있다. 기간은 나노초 단위로 타임라인을 따라 시간을 측정하는 간단한 방법이다. 기간은 인간에게 의미 있는 단위(예: 연도 또는 일수)로 시간의 양을 표현한다.

## ***Additional value types***

**Month**는 **한 달을 자체적으로 저장**한다. '**DECEMBER**'와 같이 단일 월을 별도로 저장한다.

**DayOfWeek**는 **자체적으로 요일을 저장**한다. '**TUESDAY**'와 같이 단일 요일을 별도로 저장한다.

**Year**는 **자체적으로 연도를 저장**한다. '**2010**'과 같이 단일 연도를 격리하여 저장한다.

**YearMonth**는 **날짜나 시간 없이 연도와 월을 저장**한다. ****'**2010-12**'와 같은 연도 및 월을 저장하며 신용 카드 만료에 사용될 수 있다.

**MonthDay**는 **연도나 시간 없이 월과 일을 저장**한다. '**--12-03**'과 같은 월과 일을 저장하며 연도를 저장하지 않고 생일과 같은 연례 행사를 저장하는 데 사용할 수 있다.

**OffsetTime**은 **날짜 없이 UTC의 시간과 오프셋을 저장**한다. '**11:30+01:00**'과 같은 날짜를 저장한다. ZoneOffset은 '+01:00' 형식입니다.

**OffsetDateTime**은 **날짜와 시간, UTC 기준 오프셋을 저장**한다. '**2010-12-03T11:30+01:00**'과 같은 날짜-시간을 저장한다. 때때로 XML 메시지 및 기타 형태의 지속성에서 발견되지만 전체 시간대보다 적은 정보를 포함한다.

## ***Package specification***

별도로 명시하지 않는 한 이 패키지의 클래스, 인터페이스에 있는 생성자나 메서드에 null 인자를 전달하면 `NullPointerException`이 발생한다. Javadoc "@param" 정의는 null 동작을 요약하는 데 사용된다. "@throws NullPointerException"은 각 메서드에 명시적으로 문서화되어 있지 않다.

모든 계산에서는 숫자 오버플로를 확인하고 `ArithmeticException` 또는 `DateTimeException`을 발생시켜야 한다.

## ***Design notes (non normative)***

API는 null을 초반에 reject하고 이 동작을 명확하게 설명하도록 설계되었다. 주요 Exception은 검사 또는 유효성 검사를 위해 객체를 가져와 boolean값을 반환하는 메서드이며 **일반적으로 null에 대해 false를 반환**한다.

**API는 main high-level에서 타당한 경우 type-safe되도록 설계되었다**. 따라서 날짜, 시간 및 날짜-시간의 고유한 개념에 대한 별도의 클래스와 오프셋 및 시간대에 대한 변형이 있다. 이는 많은 클래스처럼 보일 수 있지만 대부분의 애플리케이션은 5개의 날짜/시간 유형만으로 시작할 수 있다.

- Instant - 타임스탬프
- LocalDate - 시간이 없는 날짜 또는 오프셋이나 시간대에 대한 참조
- LocalTime - 날짜가 없는 시간 또는 오프셋이나 시간대에 대한 참조
- LocalDateTime - 날짜와 시간을 결합하지만 여전히 오프셋이나 시간대는 없음
- ZonedDateTime - 시간대가 포함된 "전체" 날짜 시간 및 UTC/그리니치에서 확인된 오프셋

**Instant**는 `java.util.Date`와 가장 가까운 클래스이다.  **ZonedDateTime**은 `java.util.GregorianCalendar`와 가장 가까운 클래스이다.

가능한 경우 애플리케이션은 도메인을 더 효과적으로 모델링하기 위해 **LocalDate, LocalTime** 및 **LocalDateTime**을 사용해야 한다. 예를 들어 생일은 LocalDate 코드에 저장되어야 한다. '유럽/파리'와 같은 시간대를 사용하면 계산이 상당히 복잡해진다. 많은 애플리케이션은 사용자 인터페이스(UI) 계층에 시간대가 추가된 **LocalDate**, **LocalTime** 및 **Instant**를 사용해서만 작성할 수 있다.

오프셋 기반 날짜-시간 유형 **OffsetTime** 및 **OffsetDateTime**은 주로 네트워크 프로토콜 및 데이터베이스 액세스에 사용하기 위한 것이다. 예를 들어, 대부분의 데이터베이스는 '유럽/파리'와 같은 시간대를 자동으로 저장할 수 없지만 '+02:00'과 같은 오프셋은 저장할 수 있다.

**Month**, **DayOfWeek**, **Year**, **YearMonth** 및 **MonthDay**를 포함하여 날짜의 가장 중요한 하위 부분에 대한 클래스도 제공된다. 복잡한 날짜-시간 개념을 모델링하는 데 사용될 수 있다. 예를 들어 **YearMonth**는 신용 카드 만료를 나타내는 데 유용하다.

날짜의 다양한 측면을 나타내는 클래스는 많지만, 시간의 다양한 측면을 다루는 클래스는 상대적으로 적다. 논리적 결론에 대한 유형 안전성을 따르면 시간-분, 시간-분-초 및 시간-분-초-나노초에 대한 클래스가 생성된다. 논리적으로는 순수하지만 날짜와 시간의 조합으로 인해 클래스 수가 거의 3배가 되므로 이는 실용적인 옵션이 아니었다. **따라서 LocalTime은 시간의 모든 정밀도에 사용되며 0은 낮은 정밀도를 의미하는 데 사용된다.**
최종 결론까지 완전한 타입 안정성을 따르면 HourOfDay 클래스와 DayOfMonth 클래스와 같이 날짜-시간의 각 필드에 대해 별도의 클래스가 필요하다고 주장할 수도 있다. 해당 접근 방식이 시도되었지만 Java 언어에서는 지나치게 복잡하여 유용성이 부족했다. periods에서도 비슷한 문제가 발생한다. Years, type for Minutes 등 기간단위별로 별도의 클래스를 갖는 경우가 있다. 이로 인해 많은 클래스가 발생하고 타입변환에 문제가 발생한다. 따라서 제공된 날짜-시간 유형 세트는 순수성과 실용성 사이의 절충안이다.

