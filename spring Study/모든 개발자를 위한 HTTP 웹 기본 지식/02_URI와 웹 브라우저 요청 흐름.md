## 📝 URI, URL, URN
![image](https://github.com/syoh98/TIL/assets/76934280/1d18e011-0969-4dbe-8e53-20030720e533)

* URI(Uniform Resource **Identifier**)
  * Identifier: 다른 항목과 구분하는데 필요한 정보
* URL(Uniform Resource **Locator**)
  * Locator: 리소스가 있는 위치를 지정
* URN(Uniform Resource **Name**)
  * Name: 리소스에 이름을 부여
  * 위치는 변할 수 있지만, 이름은 변하지 않는다
  * URN 이름만으로 실제 리소스를 찾을 수 있는 방법이 보편화 되지 않았다.
 
## 📝 URL 문법을 확인해보자
![image](https://github.com/syoh98/TIL/assets/76934280/c38bd008-1e18-4f08-935f-874a0c9a7daa)
1. 프로토콜(https)
   * 어떤 방식으로 자원에 접근할 것인가 하는 약속 규칙(ex.http, https, ftp)
   * http: 80포트, https: 443포트를 주로 사용, 포트는 생략이 가능하다
   * https는 http에 보안을 추가한 것이다.
2. 호스트명(www.google.com)
   * 도메인명 또는 IP 주소를 직접 사용할 수 있다
3. 포트 번호(443)
   * 일반적으로 생략하고, 생략할 경우 **http는 80, https는 443**이다
4. 패스(/search)
   * 리소스 경로. 계층적 구조이다.
5. 쿼리 파라미터(q=hello&hl=ko)
    * key=value 형태
    * ?로 시작하고 &로 추가가 가능하다 (ex.keyA=valueA&keyB=valueB)

## 📝 웹 브라우저 요청 흐름을 알아보자
![image](https://github.com/syoh98/TIL/assets/76934280/16b00d6a-42dc-4886-9b1b-a4094ddfb654)   
앞서 TCP/IP에 관해 학습했을 때, 패킷 생성 시
* 출발지 IP, PORT
* 목적지 IP, PORT   
를 추가해서 생성한다고 학습했었다.
![image](https://github.com/syoh98/TIL/assets/76934280/40bbcc4d-ac91-4933-b570-d9ada70b501e)
따라서 (출발지/목적지 IP, PORT)를 껍질마냥 씌워서 전송한다.
서버는 이 껍질을 까서 HTTP메시지를 확인한다.
</br>

![image](https://github.com/syoh98/TIL/assets/76934280/299c6028-cd94-4203-a5ee-b0ad4836a2de)   
그 다음 HTTP 응답 메시지를 보낸다.   
응답을 받은 웹 브라우저는 HTML을 렌더링한다.
