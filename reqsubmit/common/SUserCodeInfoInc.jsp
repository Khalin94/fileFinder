<%
 //�̿��� ���� ����.
 String strUserID = (String)session.getAttribute(CodeConstants.SESSION_USERID);
 if(strUserID==null || strUserID.equals("")){
 	//throw new ReqsubmitException(request.getRequestURI(),"NoSessionUserInfo","����� ID�� ���ǿ� �������� �ʳ׿�");
 	 strUserID="tester2";//���ǿ��� ���� ����� ID Test��. �ءء� �׽�Ʈ ���� ���� ���.
 }
 objUserInfo=(UserInfoDelegate)session.getAttribute(CodeConstants.USER_INFO_DELEGATE); 
 if(objUserInfo==null){
 	objUserInfo=new UserInfoDelegate(strUserID);
 	session.setAttribute(CodeConstants.USER_INFO_DELEGATE,(Object)objUserInfo);
 }
 //�ڵ� ���� ����.
  objCdinfo=CDInfoDelegate.getInstance();
%>
