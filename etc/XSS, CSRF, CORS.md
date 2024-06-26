## ⏺️ XSS(Cross-Site Scripting, 크로스사이트 스크립팅)
공격자가 입력한 악성스크립트가 사용자 측에서 응답하는 취약점으로, 사용자 입력 값에 대한 검증이 미흡하거나 출력 시 필터링 되지 않을 경우 발생한다.   
</br>

## ⏺️ CSRF(Cross-Site Request Forery)
공격자가 타 사용자의 권한을 이용해 자신이 의도한 동작을 서버에 요청하게끔 유도하는 방식이다. 서버에 사용자 요청에 대한 적절한 검증 절차가 없을 때, 정상적인 요청과 조작된 요청을 구분하지 못할 경우 발생한다.
* CSRF 공격예시
  1. 패스워드 변경 페이지에서 패스워드 변경 요청을 보내면 아래와 같은 파라미터를 전송하여 패스워드가 변경된다.   
     <img src="https://github.com/syoh98/TIL/assets/76934280/c6d37348-4734-4ada-a3cd-e3f761903d7e" width="700"/></br>
  3. 공격자는 자신이 원하는 패스워드(eqst)로 변경을 유도하는 CSRF 스크립트를 작성하여 게시글을 등록한다.   
     <img src="https://github.com/syoh98/TIL/assets/76934280/e085798d-b253-4d9a-9b27-bff12446ad5a" width="700"/></br>
  5. 피해자는 공격자가 등록한 CSRF 스크립트가 삽입된 게시글에 접근한다. 피해자 측에서 패스워드 변경 스크립트가 동작하여 피해자의 패스워드가 변경된다.   
     <img src="https://github.com/syoh98/TIL/assets/76934280/a4d1d9d3-8d4a-4e59-b524-2bb4df74a2e7" width="700"/></br>
  7. 피해자(admin)가 기존 패스워드로 로그인을 시도하면 로그인에 실패하는 것을 확인할 수 있다. 또한 공격자는 피해자의 아이디와 자신이 변경한 패스워드를 통해 피해자 계정으로 로그인할 수 있다.   
     <img src="https://github.com/syoh98/TIL/assets/76934280/8e03de68-2cb7-496f-a97e-7c0b770bb65f" width="700"/></br>   
</br>

## ✏️ XSS vs CSRF   
<img src="https://github.com/syoh98/TIL/assets/76934280/97eb97f1-37e7-47bb-8a52-b4b8e21ffbd4" width="700"/></br>
</br>

## ⏺️ CORS(Cross-Origin Resource Sharing, 교차 출처 리소스 공유)
<img src="https://github.com/syoh98/TIL/assets/76934280/6584479c-bea6-45f6-b621-fdb09a04880f" width="700"/></br>
**서로 다른 출처라도 리소스 요청, 응답을 허용할 수 있도록 하는 정책**이다.
* `출처가 교차한다`는 건 리소스를 주고 받으려는 `두 출처가 서로 다르다`는 것을 의미한다.
* 출처는 `origin`의 번역으로 **프로토콜**, **도메인(호스트 이름)**, **포트**를 의미한다.
* **사용이유**
  * 과거에는 프론트엔드와 백엔드를 따로 구성하지 않고 한 번에 구성해서 모든 처리가 같은 도메인 안에서 가능했다.
  * 현재는 클라이언트에서 API를 직접 호출하는 방식이 많아졌다. 보통 클라이언트와 API는 다른 도메인에 있는 경우가 많다. 따라서 **출처가 다르더라도 요청과 응답을 주고받을 수 있도록 서버에 리소스 호출이 허용된 출처를 명시해주는 방식**인 CORS 정책이 생겼다.   
</br>

* 참고
  * https://blog.naver.com/sk_shieldus/222902533919
  * https://blog.naver.com/sk_shieldus/222985847567?
  * https://docs.tosspayments.com/resources/glossary/corstrackingCode=blog_bloghome_searchlist
