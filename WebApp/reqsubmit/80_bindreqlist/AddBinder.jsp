<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.binder.bindDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>


<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
	//String strUserID = (String)session.getAttribute(CodeConstants.SESSION_USERID);
	//strUserID = "tester1";

	String strReqId = null;	
	String strAnsID = null;
	String strAnsIdInfo = null;
	String StstrAnsIDData = null;
	ArrayList objTotalBinderList = null;
	Hashtable objBinderHash = null;
	String strAnsFileId = null;
	String[] strReqIdArray = new String[300];
	boolean blnCheck = false;
	/* �䱸�� ���� �亯 Ȯ�� */
	int intReqCheckNum = 0;
	/* �䱸�� ���� �亯���� �� Ȯ�� */
	int intAnsCheckNum = 0;


	strReqIdArray = request.getParameterValues("ReqInfoIDs");
	//System.out.println("strReqId ="  +strReqIdArray[0]);
	bindDelegate objBindDelegate = new bindDelegate();
 	ArrayList objCheckArray = new ArrayList();
	ArrayList objAnsIDArray = new ArrayList();
	
	if (strReqIdArray != null)
	{
		int intRegIDLength = strReqIdArray.length ;
		//System.out.println("intRegIDLength =" + intRegIDLength);
		String strDeleteFileIndex = null;		
		String strBinderList = null;
		
		objTotalBinderList = (ArrayList)session.getAttribute(EnvConstants.BINDER);
		
		if(objTotalBinderList == null ){
			objTotalBinderList = new ArrayList();
			System.out.println("[AddBinder.jsp] ���δ���ϵ��� ���ǿ� ����. ");
		}		
		

		for(int i=0; i<intRegIDLength ; i++) {
			strReqId = strReqIdArray[i];
			Hashtable objHansCount	 = objBindDelegate.getAnsIDCount(strReqId);
			objBinderHash = objBindDelegate.getAnsIDArray(strReqId);
			/*for (java.util.Enumeration enum=objBinderHash.keys();enum.hasMoreElements();){
				System.out.println("[addBinder ] Key:" + (String)enum.nextElement());
			}*/			
			String strAnsInfoCount =	(String)objHansCount.get("TOTALCOUNT");
		

			Integer intFieldCnt = (Integer)objBinderHash.get("FETCH_COUNT");
			Integer objAnsInfoCount = new Integer(strAnsInfoCount);
			int intAnsInfoCount = objAnsInfoCount.intValue();
			intReqCheckNum = intReqCheckNum + intAnsInfoCount;

			int intSessionIDCount  = objTotalBinderList.size();
			//System.out.println("**** �䱸 ID " + strReqId  + " �� ���� �亯 ������ ? = " + intAnsInfoCount + " *******");
			// �䱸�� ���� �亯�� ������ŭ �亯ID�� ���ǿ� �߰��Ѵ�.

			for(int j = 0 ; j < intAnsInfoCount; j++){					
				  strAnsID = (String)((Vector)objBinderHash.get("ANS_ID")).elementAt(j);
				  strAnsFileId = (String)((Vector)objBinderHash.get("ANS_FILE_ID") ).elementAt(j) ;
				 
				  //System.out.println("[AddBinder.jsp]   �亯 ���� ID strAnsFileId = " + strAnsFileId);
				  //System.out.println("[AddBinder.jsp]  �䱸 ID�� ����  " + j + " ��° �亯 ID = " + strAnsID );
				  if(strAnsFileId=="" ||  strAnsFileId.equals("") ){
						System.out.println("[AddBinder.jsp]  �䱸 ID�� ����  " + j + " ��° �亯 ID = " + strAnsID + " �� �亯������ �����Ƿ� ���δ���Ͽ� �߰��Ҽ� ����." );
						intAnsCheckNum++;
				  }else{
					  objAnsIDArray.add(strAnsID);
				  }
			}
			//System.out.println("[AddBinder.jsp]  �� �亯id������ ? = " + objAnsIDArray.size());
			//objTotalBinderList  = objBindDelegate.checkSessionIsAnsIDs(strAnsID,objTotalBinderList);
			for(int  j = 0 ; j < objAnsIDArray.size() ; j ++){				
				  strAnsIdInfo = (String)objAnsIDArray.get(j);		
				  //System.out.println("���� �亯 id = " + strAnsIdInfo);
				  if(intSessionIDCount == 0){
						objTotalBinderList.add(strAnsIdInfo);
				  }else{
					  for(int k = 0; k < intSessionIDCount; k++) {        	    	    	
						StstrAnsIDData = (String)objTotalBinderList.get(k);
						//System.out.println("[AddBinder.jsp] ���� ���ǿ� ����ִ�  " + j + " ��° �亯 ID = " + StstrAnsIDData );
						blnCheck = false;
						if(StstrAnsIDData.equals(strAnsIdInfo)){
							 blnCheck = true;
							 objCheckArray.add(strAnsIdInfo);						 
							 break;        
						}			  					  						
					  }
					  if(!blnCheck){
							 System.out.println("���ǿ� ���� �߰��Ѵ�. strAnsID =" + strAnsIdInfo );
							 objTotalBinderList.add(strAnsIdInfo);
					  }
				  }
			}
		}

		//System.out.println("  �䱸�� ���� ��ü �亯��  ���� = " + intReqCheckNum );
		//System.out.println("  �䱸�� ���� ��ü �亯�� ����  ���� = " + intAnsCheckNum );
		//System.out.println("objTotalBinderList.size() = " + objTotalBinderList.size() + "\n\n");
		session.setAttribute(EnvConstants.BINDER,objTotalBinderList); 		
	}

%>
<html>
<head>
<title>���δ� �߰�</title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="350" border="0" cellspacing="0" cellpadding="0">
  <tr class="td_reqsubmit"> 
    <td height="5"></td>
  </tr>
  <tr> 
    <td width="350" height="34" class="soti_reqsubmit" bgcolor="#f4f4f4">&nbsp;&nbsp;<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
      <font style="font-size:14px">���δ� �߰�</font></td>
  </tr>
  <tr>
	<td height="1" bgcolor="#c0c0c0"></td>
  </tr>
  <tr> 
    <td height="10"></td>
  </tr>
  <tr> 
    <td height="23" align="left" valign="top">
		<%
			if(intReqCheckNum == intAnsCheckNum) {
		%>
		&nbsp;&nbsp;<img src="/image/common/icon_exclam_mark.gif" border="0"> �۾� ��� : <B>���δ� ��� �߰� ���� (Failed)</B>
        <p>
		&nbsp;&nbsp;<img src="/image/common/icon_exclam_mark.gif" border="0"> �� �� : �䱸�� ���� �亯������ �������� �ʽ��ϴ�.<br>
		<%
			} else {
		%>
		&nbsp;&nbsp;<img src="/image/common/icon_exclam_mark.gif" border="0"> �۾� ��� : <B>���δ� ��� �߰� ���� (Success)</B>
        <p>
		&nbsp;&nbsp;<img src="/image/common/icon_exclam_mark.gif" border="0"> �� �� : ������ ÷�ε��� ���� �亯�� �߰����� �ʽ��ϴ�. <br>
		<%
			}
		%>

	</td>
  </tr>
  <tr> 
    <td height="30"></td>
  </tr>
  <tr> 
    <td height="40" align="left">
	   <table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="25" align="right">&nbsp;
		  <a href="javascript:window.close();opener.location.href='/reqsubmit/80_bindreqlist/BindList.jsp?binderSortField=ANS_DT&binderSortMtd=DESC&binderPageNum=1'"><img src="/image/button/bt_binderReqList.gif" width="109" height="20" border="0"></a>
		  </td>
        </tr>
      </table></td>
  </tr>
  <tr>
	<td height="1" bgcolor="#c0c0c0"></td>
  </tr>
  <tr> 
    <td height="25" align="right" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="/image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
</table>
<p> </p>
</body>
</html>