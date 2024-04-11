**✏️반복구문에서의 속도는?**   
* 반복구문의 종류
  * for
    * A case:   
      `for(int loop=0;loop<list.size();loop++)`
    * B case:   
      `int listSize=list.size();`   
      `for(int loop=0;loop<listSize;loop++)`   
      ➡️ 매번 반복하면서 list.size()를 호출하기 때문에 필요없는 size() 메서드의 반복 호출을 없애자
    * For-Each
      * 별도로 형변환하거나 get() 또는 elementAt()을 호출할 필요 없이 순서에 따라 String 객체를 for문장 안에서 사용할 수 있기 때문에 편리하다
      * 데이터의 첫 번째 값부터 마지막까지 처리해야 할 경우에만 유용하다.
    * JMH 측정결과 for-each > A case > B case 순으로 오래걸렸다. 하지만 크게 차이는 없다.
  * do-while
  * while
* while문은 잘못하면 무한 루프에 빠질 수 있기 때문에 되도록 for문을 사용하자
 
  **✏️반복구문에서의 필요 없는 반복**   
  가장 많이 하는 실수 중 하나는 반복 구문에서 계속 필요없는 메서드 호출을 하는 것이다.
  * 예시코드(TreeSet 형태의 데이터를 갖고 있는 DataVO에서 TreeSet을 하나 추출하여 처리하는 부분)

  ```java
  public void sample(DataVO data, String key) {
    TreeSet treeSet2 = null;
    treeSet2=(TreeSet)data.get(key);
    if(treeSet2 != null) {
      for(int i=0; i<treeSet2.size(); i++) {
        DataVO2 data2=(DataVO2)treeSet2.toArray()[i];
        // ...
      }
    }
  } 
  ```
  ➡️ toArray() 메서드를 반복수행하는 문제가 있다.
  
  ```java
  public void sample(DataVO data, String key) {
    TreeSet treeSet2 = null;
    treeSet2=(TreeSet)data.get(key);
    if(treeSet2 != null) {
      DataVO2[] dataVO2=(DataVO2) treeSet2.toArray();
      int treeSet2Size = treeSet2.size();
      for(int i=0; i<treeSet2Size; i++) {
        DataVO2 data2=DataVO2[i];
        // ...
      }
    }
  } 
  ```
  ➡️ 이런식으로 고치자.
