<%@ page import="java.util.*"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>


<%
	String strMessage = "";
	String strError = "no";
	String strUserId   = "";
	
	Vector objItetIngPrgId = new Vector();
	Vector objItetIngPrgNm = new Vector();
	Vector objItetIngPrgUrl = new Vector();

	Vector objItetEdPrgId = new Vector();
	Vector objItetEdPrgNm = new Vector();
	Vector objItetEdPrgUrl = new Vector();
	try
	{
		Vector objPrgIdVt = new Vector();
		Vector objPrgNmVt = new Vector();
		Vector objPrgUrlVt = new Vector();

		ArrayList objItetArry = new ArrayList();
		String strId = "";	
		String strNm = "";	
		Hashtable objItetHt = new Hashtable();
	
		String strUserGubn = (String)session.getAttribute("IS_REQUESTER");
		String strInOutGbun = (String)session.getAttribute("INOUT_GBN");
		strUserId = (String)session.getAttribute("USER_ID");
		
		nads.dsdm.app.activity.useritet.UserItetDelegate objUserItetDelegate = new nads.dsdm.app.activity.useritet.UserItetDelegate();
		
		/***********���������� ������ �� �ִ� ���α׷�**************/
		Hashtable objPrgHt = objUserItetDelegate.selectItetAppinfo();
		objPrgIdVt = (Vector)objPrgHt.get("APP_ID");   //���α׷�ID
		objPrgNmVt = (Vector)objPrgHt.get("APP_NM");  //���α׷���
		objPrgUrlVt = (Vector)objPrgHt.get("APP_URL");  //���α׷�URL
		/*******************************************************/
		objItetArry = objUserItetDelegate.selectUserItetinfo(strUserId);	//����ڰ� ������ ���������� ID
		
		String strPrgUrl = "";
		String strPrgSrc = "";
		Vector objPrgSrcVt = new Vector();
		String strPrgId = "";
		String strPrgNm = "";

		boolean bnUserItetYn = false;
		for(int i=0; i<objPrgIdVt.size(); i++){
			bnUserItetYn = false;
			
			strPrgId = (String)objPrgIdVt.elementAt(i);
			strPrgNm = (String)objPrgNmVt.elementAt(i);
			strPrgUrl = (String)objPrgUrlVt.elementAt(i);
			
			objPrgSrcVt = nads.lib.util.ActComm.makeNoType(strPrgUrl, "/");
			strPrgSrc = (String)objPrgSrcVt.elementAt(objPrgSrcVt.size() - 1);

			if(strUserGubn.equals("false") &&  strPrgSrc.equals("ROpenReqList.jsp")) continue;   //�������� ��� �����䱸���� �������� �ʴ´�.
			if(strInOutGbun.equals("X") &&  strPrgSrc.equals("ISearch_Relation.jsp")) continue;   //�ܺλ������ ��� ���ñ������Ʈ��ȸ�� �������� �ʴ´�.
			if(strInOutGbun.equals("X") &&  strPrgSrc.equals("OpenBizInfo.jsp")) continue;   //�ܺ� ������� ��� ������������ �������� �ʴ´�.(2004.04.28����)
			if(strInOutGbun.equals("X") &&  strPrgSrc.equals("BizInfo.jsp")) continue;  //�ܺ� ������� ��� �������� �������� �ʴ´�.

		 	if(strUserGubn.equals("false") &&  strPrgSrc.equals("SGovSubDataBoxList.jsp")){
				strPrgNm = "ȸ���ڷ� �����";
			}else if(strUserGubn.equals("true") &&  strPrgSrc.equals("SGovSubDataBoxList.jsp")){
				strPrgNm = "ȸ���ڷ���";
			}
 				
		 	if(strUserGubn.equals("false") &&  strPrgSrc.equals("RSubReqList.jsp")){
				strPrgNm = "�űԿ䱸���";
			}else if(strUserGubn.equals("true") &&  strPrgSrc.equals("RSubReqList.jsp")){
				strPrgNm = "�ű�������";
			}				

			for(int j=0; j<objItetArry.size(); j++){
				objItetHt = (Hashtable)objItetArry.get(j) ;
				strId = (String)objItetHt.get("APP_ID");
			
				if(strId.equals((String)objPrgIdVt.elementAt(i))){
					bnUserItetYn = true;
					break;
				}//if(strId.equals((String)objPrgIdVt.elementAt(i)))
			}//for(int j=0; j<objPrgIdVt.size(); j++)

			if (bnUserItetYn == true){
				objItetEdPrgId.add(strPrgId);
				objItetEdPrgNm.add(strPrgNm);
				objItetEdPrgUrl.add(strPrgUrl);
			}else{
				objItetIngPrgId.add(strPrgId);
				objItetIngPrgNm.add(strPrgNm);
				objItetIngPrgUrl.add(strPrgUrl);			
			}
		}//for(int i=0; i<objItetArry.size(); i++)
	}
	catch(AppException objAppEx)
	{	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
		strError = "yes";
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
%>