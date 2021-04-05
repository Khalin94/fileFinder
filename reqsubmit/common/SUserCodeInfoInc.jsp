<%
 //이용자 정보 설정.
 String strUserID = (String)session.getAttribute(CodeConstants.SESSION_USERID);
 if(strUserID==null || strUserID.equals("")){
 	//throw new ReqsubmitException(request.getRequestURI(),"NoSessionUserInfo","사용자 ID가 세션에 존재하지 않네요");
 	 strUserID="tester2";//세션에서 받을 사용자 ID Test용. ※※※ 테스트 끝에 삭제 요망.
 }
 objUserInfo=(UserInfoDelegate)session.getAttribute(CodeConstants.USER_INFO_DELEGATE); 
 if(objUserInfo==null){
 	objUserInfo=new UserInfoDelegate(strUserID);
 	session.setAttribute(CodeConstants.USER_INFO_DELEGATE,(Object)objUserInfo);
 }
 //코드 정보 설정.
  objCdinfo=CDInfoDelegate.getInstance();
%>
