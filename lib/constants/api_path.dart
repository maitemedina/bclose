class ApiPath{
  static final String BASE_URL =  "https://negocia.cv:3010/api/v1/";
  //static final String BASE_URL ="http://192.168.1.138:3010/api/v1/";
  static final String IMG_BASE_URL =  "https://negocia.cv/portal/";
  static final String CHAT_IMG_BASE_URL = "https://negocia.cv/portal/";

  static getBaseImageUrl(String url){
    return url.startsWith("http")? url : IMG_BASE_URL + url;
  }
}


