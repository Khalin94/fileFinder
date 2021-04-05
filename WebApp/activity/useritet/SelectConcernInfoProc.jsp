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
		
		/***********관심정보로 선택할 수 있는 프로그램**************/
		Hashtable objPrgHt = objUserItetDelegate.selectItetAppinfo();
		objPrgIdVt = (Vector)objPrgHt.get("APP_ID");   //프로그램ID
		objPrgNmVt = (Vector)objPrgHt.get("APP_NM");  //프로그램명
		objPrgUrlVt = (Vector)objPrgHt.get("APP_URL");  //프로그램URL
		/*******************************************************/
		objItetArry = objUserItetDelegate.selectUserItetinfo(strUserId);	//사용자가 설정한 관심정보의 ID
		
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

			if(strUserGubn.equals("false") &&  strPrgSrc.equals("ROpenReqList.jsp")) continue;   //제출자인 경우 공개요구함을 보여주지 않는다.
			if(strInOutGbun.equals("X") &&  strPrgSrc.equals("ISearch_Relation.jsp")) continue;   //외부사용자인 경우 관련기관사이트조회를 보여주지 않는다.
			if(strInOutGbun.equals("X") &&  strPrgSrc.equals("OpenBizInfo.jsp")) continue;   //외부 사용자인 경우 공개업무함을 보여주지 않는다.(2004.04.28삭제)
			if(strInOutGbun.equals("X") &&  strPrgSrc.equals("BizInfo.jsp")) continue;  //외부 사용자인 경우 업무함을 보여주지 않는다.

		 	if(strUserGubn.equals("false") &&  strPrgSrc.equals("SGovSubDataBoxList.jsp")){
				strPrgNm = "회의자료 등록함";
			}else if(strUserGubn.equals("true") &&  strPrgSrc.equals("SGovSubDataBoxList.jsp")){
				strPrgNm = "회의자료함";
			}
 				
		 	if(strUserGubn.equals("false") &&  strPrgSrc.equals("RSubReqList.jsp")){
				strPrgNm = "신규요구목록";
			}else if(strUserGubn.equals("true") &&  strPrgSrc.equals("RSubReqList.jsp")){
				strPrgNm = "신규제출목록";
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