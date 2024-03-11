## 📕 입출력   
입출력이란? 컴퓨터 내부 또는 외부의 장치와 프로그램간의 데이터를 주고받는 것   
ex) 키보드로부터 데이터 입력 받기, ```System.out.println()```을 이용해서 화면에 출력하기   

## 📙 스트림   
스트림이란? 데이터를 운반하는데 사용되는 연결통로   
스트림은 **단방향통신**만 가능하기 때문에 하나의 스트림으로 입력과 출력을 동시에 처리할 수 없음   
   
## 💻 바이트기반 스트림   
스트림은 바이트 단위로 데이터를 전송   
**-> 바이트 기반이라는 것은 입출력의 단위가 1byte라는 것**   
<img src="https://github.com/syoh98/TIL/assets/76934280/bdf86cb8-b9ce-4371-9790-fda104397dd4" width="600"/></br>   
* InputStream, OutputStream
* ByteArrayInputStream, ByteArrayOutputStream
* FileInputStream, FileOutputStream
   
## 💻 보조 스트림
바이트기반 스트림 외에도 **스트림의 기능을 보완**하기 위한 보조스트림이 제공   
보조스트림은 실제 데이터를 주고받는 스트림이 아니기 때문에 데이터를 입출력할 수 있는 기능은 없지만, **스트림의 기능을 향상시키거나 새로운 기능을 추가**할 수 있음   
-> 따라서 스트림을 먼저 생성한 후 보조스트림을 생성해야함
* 바이트기반 보조스트림
  * FilterInputStream, FilterOutputStream
  * BufferedInputStream, BufferedOutputStream
  * DataInputStream, DataOutputStream
  * SequenceInputStream
  * PrintStream
* 문자기반 보조스트림
  * BufferedReader, BufferedWriter
  * InputStreamReader, OutputStreamWriter
   
## 💻 문자기반 스트림
java에서는 한 문자를 의미하는 **char형이 1byte가 아닌 2byte이기 때문에, 바이트기반 스트림으로 문자를 처리하는데 어려움**이 있음   
-> 이 점을 보완하기 위해 문자 기반의 스트림이 제공   
-> 문자데이터를 입출력할 때는 바이트기반 스트림 대신 문자기반 스트림을 사용하자   
보조스트림 역시 문자기반 보조스트림이 존재, 사용목적과 방식은 바이트기반 보조스트림과 다르지 않음
* Reader, Writer
* FileReader, FileWriter
* PipedReader, PipedWriter
* StringReader, StringWriter
