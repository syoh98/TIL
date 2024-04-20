## ✏️ 자바에서 사용하는 XML 파서의 종류는?
* XML의 가장 큰 장점은 누구나 데이터의 구조를 정의하고 그 정의된 구조를 공유함으로써 일관된 데이터 전송 및 처리를 할 수 있다는 점이다.
  * ➡️ 이러한 특성 때문에 데이터를 파싱해야한다
* 파서의 종류
  ![image](https://github.com/syoh98/TIL/assets/76934280/3fd309a0-eb99-437d-9f23-b020de935bf2)   
  * **SAX(Simple API for XML Processing)**
    * 순차적 방식으로 XML을 처리한다.
    * 각 XML의 노드를 읽는 대로 처리하기 때문에 메모리의 부담이 DOM에 비해서 많지 않다.
    * Content 핸들러, Error 핸들러, DTD 핸들러, Entity 리졸버를 통해 순차적 이벤트를 처리하기 때문에 이미 읽은 데이터의 구조를 수정하거나 삭제하기 어렵다.
  * **DOM(Document Object Model)**
    * 모든 XML을 읽어서 트리를 만든 후 XML을 처리하는 방식이다.
    * 읽은 XML을 통하여 노드를 추가, 수정, 삭제하기 쉬운 구조로 되어 있다.
    * 메모리에 올려서 작업하기 때문에 메모리에 부담이 간다.
  * XSLT(Xml Stylesheet Language for Transformations)
    * SAX, DOM, InputStream을 통해서 들어온 데이터를 원하는 형태의 화면으로 구성하는 작업을 수행한다.
    * XMl이 화면에서 보기 쉬운 데이터가 되도록 처리한다.
</br>

## ✏️ SAX 파서는 어떻게 사용할까?
* 기본적으로 제공되는 SAX API
  * SAXParseFactory: 파싱을 하는 파서 객체를 생성하기 위한 추상 클래스
  * SAXParser: 여러 종류의 `parse()` 메서드를 제공하는 추상 클래스
  * DefaultHandler: ContentHandler, ErrorHandler, DTDHandler, EntityResolver를 구현한 클래스. 상황에 따라 XML을 처리할 때 사용
  * ContentHandler: XML의 태그의 내용을 읽기 위한 메서드를 정의한 인터페이스
  * ErrorHandler: 에러를 처리하는 메서드가 정의되어 있는 인터페이스
  * DTDHandler: 기본 DTD 관련 이벤트를 식별하기 위한 인터페이스
  * EntityResolve: URI를 통한 식별을 하기 위한 인터페이스
</br>

## ✏️ DOM 파서는 어떻게 사용할까?
* XML을 트리 형태의 데이터로 먼저 만든 후, 그 데이터를 가공하는 방식을 사용
* DOM에서의 주요 클래스
  * DocumentBuilderFactory: 파싱을 하는 파서 객체를 생성하기 위한 추상 클래스
  * DocumentBuilder: 여러 종류의 `parse()` 메서드를 제공하는 추상 클래스
  * Document: SAX와 다르게 파싱을 처리한 결과를 저장하는 클래스
  * Node: XML과 관련된 모든 데이터릐 상위 인터페이스. 단일 노드에 대한 정보를 포함하고 있다.
* SAX와 다른 점은 따로 핸들러를 지정하지 않고, 파싱한 데이터를 Document 클래스의 객체에 담아서 리턴해준다는 것이다.
* **XML 파일의 크기가 클 때 DOM 파서를 사용한다면, `OutOfMemoryError`가 빈번히 일어날 확률이 매우 크다**
</br>

## ✏️ XML 파서가 문제가 된 사례
* 한 사이트에서 XML로 문서를 주고 받는다.
* XML을 파싱하기 위해서 파서가 있어야 하는데, 대부분의 AWS에는 파서가 내장되어 있다.
  * ➡️ 해당 케이스의 경우 내장된 파서가 문제였다
* 해당 파서는 특수문자가 XML에 들어오면 무한 루프를 돌아 OutOfMemoryError가 발생한다.
* 그러므로 WAS에 있는 파서를 쓰면 안되고, 아파치 그룹에서 제공하는 SAX 파서를 사용해야 했었다.
</br>

## ✏️ JSON과 파서들
* JSON의 구조
  * name-value 형태의 쌍으로 collection 타입
  * 값의 순서가 있는 목록 타입
* **JSON도 많은 CPU와 메모리를 점유하며 응답 시간도 느리다**
* JSON 데이터는 `Serialize`와 `Deserialize`를 처리하는 성능이 좋지 않기 때문에 XML 파서보다 JSON 파서가 더 느린경우가 대부분이다
  * `Serialize`: 데이터를 전송할 수 있는 상태로 처리하는 것
  * `Deserialize`: 전송 받은 데이터를 사용 가능한 상태로 처리하는 것
</br>

## ✏️ 데이터 전송을 빠르게 하는 라이브러리 소개
* arvo
* protobuf
* thrift   
➡️ 서버와 서버간, 서버와 클라이언트 사이에 데이터를 주고 받기 위해 어떤 자바 라이브러리를 사용할지에 대해서는 성능 비교를 통해 사이트에 가장 적합한 라이브러리를 선택하는 것이 가장 좋다.
